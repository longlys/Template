//
//  AppOpenAdManager.swift
//  InhouseManager
//
//  Created by LongLy on 15/02/2023.
//
//
import GoogleMobileAds

protocol AppOpenAdManagerDelegate: AnyObject {
    /// Method to be invoked when an app open ad is complete (i.e. dismissed or fails to show).
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

class AppOpenAdManager: NSObject {
    let timeoutInterval: TimeInterval = 4 * 3_600
    var appOpenAd: GADAppOpenAd?
    weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
    var isLoadingAd = false
    var isShowingAd = false
    var loadTime: Date?
    static let shared = AppOpenAdManager()

    var theAd: GADAppOpenAd? = nil
    var loadingId: Double = 0

    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        // Check if ad was loaded more than n hours ago.
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }

    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }

    private func appOpenAdManagerAdDidComplete() {
        // The app open ad is considered to be complete when it dismisses or fails to show,
        // call the delegate's appOpenAdManagerAdDidComplete method if the delegate is not nil.
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
    }

    func loadAd() {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
#if DEBUG
        let adUnitId = "ca-app-pub-3940256099942544/3419835294"
#else
        let adUnitId = remoteConfig.configValue(forKey: "AOA_AD_UNIT_ID").stringValue ?? ""
#endif
        print("Start loading app open ad.")
        GADAppOpenAd.load(
            withAdUnitID: adUnitId,
            request: GADRequest(),
            orientation: UIInterfaceOrientation.portrait
        ) { ad, error in
            self.isLoadingAd = false
            if let error = error {
                self.appOpenAd = nil
                self.loadTime = nil
                print("App open ad failed to load with error: \(error.localizedDescription).")
                return
            }

            self.appOpenAd = ad
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            print("App open ad loaded successfully.")
        }
    }

    func showAdIfAvailable(viewController: UIViewController) {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            print("App open ad is already showing.")
            return
        }
        // If the app open ad is not available yet but it is supposed to show,
        // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
        // method and load a new ad.
        if !isAdAvailable() {
            print("App open ad is not ready yet.")
            appOpenAdManagerAdDidComplete()
            loadAd()
            return
        }
        if let ad = appOpenAd {
            print("App open ad will be displayed.")
            isShowingAd = true
            ad.present(fromRootViewController: viewController)
        }
    }
}

extension AppOpenAdManager: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App open ad is will be presented.")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad was dismissed.")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }

    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        print("App open ad failed to present with error: \(error.localizedDescription).")
        appOpenAdManagerAdDidComplete()
        loadAd()
    }
}
