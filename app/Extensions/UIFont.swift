//
//  UIFont.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import UIKit
import SwiftUI

extension UIFont {

    // MARK: Static

    static func getFontOrDefault(font: UIFont?, size: CGFloat) -> UIFont {
        guard let font = font else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    enum FontWeight: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case extraBold = "ExtraBold"
        case extraBoldItalic = "ExtraBoldItalic"
        case extraLight = "ExtraLight"
        case extraLightItalic = "ExtraLightItalic"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case regular = "Regular"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case semiBold = "SemiBold"
        case semiBoldItalic = "SemiBoldItalic"
        case thin = "Thin"
        case thinItalic = "ThinItalic"
    }

//    private static let primary = "Helvetica"
//
//    // MARK: Helvetica
//
//    class func primary(size: CGFloat, weight: FontWeight) -> UIFont {
//        return getFontOrDefault(font: UIFont(name: "\(primary)-\(weight)", size: size), size: size)
//    }

}

extension Font {

    // MARK: Static

    static func getFontOrDefault(font: Font?, size: CGFloat) -> Font {
        guard let font = font else {
            return Font.system(size: size)
        }
        return font
    }

    enum FontWeight: String {
        case bold = "Bold"
        case regular = "Regular"
        case medium = "Medium"
    }

    private static let primary = "Roboto"

    static func getPrimaryFont(size: CGFloat, weight: FontWeight) -> Font {
        return getFontOrDefault(font: Font.custom("\(primary)-\(weight)", size: size), size: size)
    }
}
