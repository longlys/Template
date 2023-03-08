//
//  IHSplashViewController.swift
//  InhouseManager
//
//  Created by LongLy on 15/02/2023.
//

import UIKit

class IHSplashViewController: UIViewController,  AppOpenAdManagerDelegate {
    /// Number of seconds remaining to show the app open ad.
    /// This simulates the time needed to load the app.
    var secondsRemaining: Int = 5
    /// The countdown timer.
    var countdownTimer: Timer?
    /// Text that indicates the number of seconds left to show an app open ad.
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        AppOpenAdManager.shared.appOpenAdManagerDelegate = self
        startTimer()
    }

    @objc func decrementCounter() {
        secondsRemaining -= 1
        if secondsRemaining > 0 {
        } else {
            countdownTimer?.invalidate()
            AppOpenAdManager.shared.showAdIfAvailable(viewController: self)
        }
    }

    func startTimer() {
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(IHSplashViewController.decrementCounter),
            userInfo: nil,
            repeats: true)
    }

    func startMainScreen() {
        let mainViewController = IHExampleViewController()
        present(mainViewController, animated: true) {
            self.dismiss(animated: false) {
                let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                keyWindow?.rootViewController = mainViewController
            }
        }
    }

    // MARK: AppOpenAdManagerDelegate
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        startMainScreen()
    }
}
