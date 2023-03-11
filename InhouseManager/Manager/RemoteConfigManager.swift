//
//  RemoteConfigManager.swift
//  InhouseManager
//
//  Created by LongLy on 10/03/2023.
//

import Foundation
import FirebaseRemoteConfig

let ConfigKey : String = "Inhouse"
class RemoteConfigManager {
    static var shared = RemoteConfigManager()
    var remoteConfig : RemoteConfig?

    init () {
        print("\n ===Init Remote ConfigManager==== \n")
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        remoteConfig?.fetch { (status, error) -> Void in
            let jsonString = self.remoteConfig?.configValue(forKey: ConfigKey).stringValue
            do {
                let decoder = JSONDecoder()
                let jsonData = jsonString?.data(using: .utf8)
                let decodedPill = try decoder.decode(Config.self, from:jsonData!)
                print("===> Inhouse Paser :\(decodedPill)")
            } catch {
                print(error)
            }
            if status == .success {
                print("Config fetched!")
                self.remoteConfig?.activate { changed, error in
                    print("Changed activate: \(changed)")
                    print("Error activate: \(error)")
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

struct Config : Codable {
    var bannerText: String
    var bonusCoins: Int
    var maxDisplayRetries: Int

    enum CodingKeys: String, CodingKey {
        case bannerText = "banner_text"
        case bonusCoins = "bonus_coins"
        case maxDisplayRetries = "max_display_retries"
    }

}
