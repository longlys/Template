//
//  ThemeColor.swift
//  InhouseManager
//
//  Created by LongLy on 15/02/2023.
//

import UIKit

struct ColorManager {

    // tin color
    static func getMainColor() -> UIColor {
        return UIColor(named: "MainColor")!
    }

    // Background color
    static func getBackgroundColor() -> UIColor {
        return UIColor(named: "BackgroundCell")!
    }

    // Tabble/Collection Background color
    static func getTabbleCollectionColor() -> UIColor {
        return UIColor(named: "BackgroundCell")!
    }

    // cell Tabble/Collection Background color
    static func getCellTabbleCollectionColor() -> UIColor {
        return UIColor(named: "BackgroundCell")!
    }

    // Title Color
    static func getTitleColor() -> UIColor {
        return UIColor(named: "TitleText")!
    }

    // Sub Title Color
    static func getSubTitleColor() -> UIColor {
        return UIColor(named: "SubTitleText")!
    }

    // Title Button Color
    static func getTitleButtonColor() -> UIColor {
        return UIColor(named: "SubTitleTextButton")!
    }

    // Background Button Color
    static func getBackgroundButtonColor() -> UIColor {
        return UIColor(named: "BackgroundButton")!
    }

}

struct FontSizeManager {
    static func setBoldFontSulphurWithSize(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SulphurPoint-Bold", size: size) else { return UIFont.systemFont(ofSize: size) }
        return font
    }

    static func setLightFontSulphurWithSize(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SulphurPoint-Light", size: size) else { return UIFont.systemFont(ofSize: size) }
        return font
    }

    static func setRegularFontSulphurWithSize(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "SulphurPoint-Regular", size: size) else { return UIFont.systemFont(ofSize: size) }
        return font
    }
}

