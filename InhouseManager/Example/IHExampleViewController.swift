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
    // MARK: - IBOutlet & Variables
    @IBOutlet weak var buttonInterstitialAds: UIButton!
    @IBOutlet weak var buttonRewardedAd: UIButton!
    @IBOutlet weak var lblRewardAmount: UILabel!

    // MARK: - Other Method
    func setupUI() {
        buttonInterstitialAds.addTarget(self, action: #selector(didTapButtonInterstitialAds), for: .touchUpInside)
        buttonRewardedAd.addTarget(self, action: #selector(didTapButtonRewardedAd), for: .touchUpInside)
        AdmobManager.shared.createAndLoadBanner(self)
    }

    // Show Alert
    func showAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - View Life Cycle
extension IHExampleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}


//MARK:- IBAction
extension IHExampleViewController {
    @objc func didTapButtonInterstitialAds() {
        AdmobManager.shared.showInterstitial(self)
        self.showAlert(title: "interstitial ad isn't available yet.", message: "Ad wasn't ready")

    }

    @objc func didTapButtonRewardedAd() {
        AdmobManager.shared.showRewardedAd(self) { (amount,success) in
            if success {
                self.lblRewardAmount.text = "Current: \(amount)"
            } else {
                self.showAlert(title: "Rewarded ad isn't available yet.", message: "The rewarded ad cannot be shown at this time")
            }
        }
    }
}
