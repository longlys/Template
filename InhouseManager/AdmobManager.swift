//
//  AdmobManager.swift
//  InhouseManager
//
//  Created by LongLy on 15/02/2023.
//

import Foundation
import UIKit
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds
import FirebaseRemoteConfig


struct ConfigAds: Codable {
    let keyIOS : String
    let keyAndroid : String
    let count : Int
    let isShow : Bool
    enum CodingKeys: String, CodingKey {
        case keyIOS
        case keyAndroid
        case count
        case isShow
    }
}

class AdmobManager: NSObject {
    static var shared = AdmobManager()

    private var remoteConfig: RemoteConfig = {
        let r = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        r.configSettings = settings
        return r
    }()

    private var IDFA: Bool
    private var interAd : GAMInterstitialAd? = nil
    private var block : ((_ showSt: Bool)->Void)? = nil
    private var iCounter = 0

    var theAd: GADAppOpenAd? = nil
    var loadingId: Double = 0

    private override init() {
        if #available(iOS 14, *) {
            IDFA = false
        } else {
            IDFA = true
        }
    }

    func preloadRemoteConfig() {
        remoteConfig.fetch { [weak remoteConfig](status, error) -> Void in
            if status == .success {
                remoteConfig?.activate()
                remoteConfig?.activate { changed, error in
                    print(changed)
                }
                self.loadAdFromRemoteConfig()
            }
        }
    }

    func showInterstitialAd(vc: UIViewController, _ block: ((_ showSt: Bool)->Void)?) {
        let isPro = false//UserDefaults.standard.bool(forKey: "ISPRO")
        if isPro {
            block?(true)
            return
        }

        let ad = self.interAd
        var theVc: UIViewController = vc
        if (ad != nil) {
            do {
                while (theVc.presentedViewController != nil) {
                    theVc = theVc.presentedViewController ?? theVc
                }
                try ad!.canPresent(fromRootViewController: theVc)
                self.block = block
                ad!.fullScreenContentDelegate = self
                ad!.present(fromRootViewController: theVc)
                //block will be called after ad is dismissed
                return
            } catch _ {
                self.block = nil
            }
        }
        self.block = nil
        DispatchQueue.main.async {
            block?(false)
        }
    }

    func loadAdFromRemoteConfig() {
        let isPro = UserDefaults.standard.bool(forKey: "ISPRO")
        if isPro {
            return
        }

        let request = GAMRequest()
        var adUnitId = "/6499/example/interstitial"
        var count = 2
        #if !DEBUG
        let jsonString = remoteConfig.configValue(forKey: "INTER_AD").stringValue ?? ""
        let dicInter = paserStringToJson(jsonString)
        if let interConfigAds = dicInter {
            adUnitId = interConfigAds.keyIOS
            count = interConfigAds.count
        }
        #endif
        if (interAd == nil) {
            GAMInterstitialAd.load(withAdManagerAdUnitID: adUnitId, request: request) { [self] ad, error in
                interAd = ad
            }
        }
    }


    func paserStringToJson(_ string: String) -> ConfigAds? {
        let jsonData = string.data(using: .utf8)!
        do {
            let configAdsObject = try JSONDecoder().decode(ConfigAds.self, from: jsonData)
            return configAdsObject
        } catch{ }
        return nil
    }
}

extension AdmobManager: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if ad === self.interAd {
            self.interAd = nil
            block?(false)
            block = nil
            iCounter = 0
        }
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if ad === self.interAd {
            self.interAd = nil
            block?(false)
            block = nil
            iCounter = 0
        }
        loadAdFromRemoteConfig()
    }
}

