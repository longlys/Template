//
//  IHExampleViewController.swift
//  InhouseManager
//
//  Created by LongLy on 15/02/2023.
//

import UIKit
import GoogleMobileAds

let AdMobAdUnitID = "ca-app-pub-3940256099942544/2934735716"

class IHExampleViewController: UIViewController {
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var lbText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.delegate = self
        bannerView.adUnitID = AdMobAdUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    @IBAction func showhidenbanner(_ sender: UIButton) {
        bannerView.isHidden = !bannerView.isHidden
        if !bannerView.isHidden {
            bannerView.load(GADRequest())
        }
    }

    @IBAction func showhidenintertisial(_ sender: UIButton) {
        AdmobManager.shared.showInterstitialAd(vc: self) { showSt in
            self.dismiss(animated: true)
        }
    }

    @IBAction func showhidenOpenApp(_ sender: UIButton) {

    }
}

// MARK: - GADBannerViewDelegate
extension IHExampleViewController : GADBannerViewDelegate {
    // Called when an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(#function)
    }

    // Called when an ad request failed.
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("\(#function): \(error.localizedDescription)")
    }

    // Called just before presenting the user a full screen view, such as a browser, in response to
    // clicking on an ad.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(#function)
    }

    // Called just before dismissing a full screen view.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }

    // Called just after dismissing a full screen view.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }

    // Called just before the application will background or exit because the user clicked on an
    // ad that will launch another application (such as the App Store).
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print(#function)
    }
}


extension Date {
    func dateTostring() -> String {

        return "date"
    }

    func stringToDate() -> Date {

        return Date()
    }

    func dateToDateFormat() -> Date {

        return Date()
    }

    func stringToDateFormat() -> Date {
        return Date()
    }

    func stringToStringWithDateFormat() -> String {

        return "date"
    }
}
