//
//  AdmobManager.swift
//  InhouseManager
//
//  Created by LongLy on 15/02/2023.
//
//
import Foundation
import UIKit
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds


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
    static let shared = AdmobManager()

    private var IDFA: Bool
    var interstitial: GADInterstitialAd?
    var rewardedAds: GADRewardedAd?
    var rewardAmount = 0
    var bannerView: GADBannerView!

    override init() {
        if #available(iOS 14, *) {
            self.IDFA = false
        } else {
            self.IDFA = true
        }
        print("AdmobManager init IDFA")
    }

    func loadAllAdsWhenStart() {
        print("loadAllAdsWhenStart AdmobManager ")
        self.loadInterstitial()
        self.createAndLoadRewardedAd()
    }

    // Banner Ad
    func createAndLoadBanner(_ viewController: UIViewController) {
        print("Google Mobile Ads SDK version: \(GADMobileAds.sharedInstance().sdkVersion)")
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "/6499/example/banner"
        bannerView.rootViewController = viewController
        bannerView.load(GAMRequest())
        bannerView.delegate = self
    }

    func addBannerViewToView(_ bannerView: GADBannerView, viewController: UIViewController) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(bannerView)
        viewController.view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: viewController.bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: viewController.view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    // Interstitial Ad
    private func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request
        ) { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            print("Loading Succeeded Interstitial")
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }

    public func showInterstitial(_ viewController: UIViewController) {
        if let ad = self.interstitial {
            ad.present(fromRootViewController: viewController)
        } else {
        }
    }

    // Rewarded Ad
    private func createAndLoadRewardedAd() {
        GADRewardedAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()
        ) { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            print("Loading Succeeded Rewarded")
            self.rewardedAds = ad
            self.rewardedAds?.fullScreenContentDelegate = self
        }
    }

    public func showRewardedAd(_ viewController: UIViewController, complete: @escaping (_ amount: Double,_ success: Bool) ->Void) {
        if let ad = rewardedAds {
            ad.present(fromRootViewController: viewController) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.type)")
                // TODO: Reward the user.
                self.createAndLoadRewardedAd()
                complete(reward.amount.doubleValue, true)
            }
        } else {
            complete(0, false)
        }
    }
}

// MARK: - GADInterstitialDelegate - GADFullScreenContentDelegate
extension AdmobManager : GADFullScreenContentDelegate {
     func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad will present full screen content.")
     }

     func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)
     {
       print("Ad failed to present full screen content with error \(error.localizedDescription).")
     }

     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
         print("Ad did dismiss full screen content.")
         loadInterstitial()
     }

}

// MARK: - GADBannerViewDelegate
extension AdmobManager : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        guard let rootViewController = bannerView.rootViewController else { return }
        addBannerViewToView(bannerView, viewController: rootViewController)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
