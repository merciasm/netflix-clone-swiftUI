//
//  UIColor.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    static let primary = UIColor("#00a03f")
    static let lightGray = UIColor("#798296")
    static let darkGreyBlue = UIColor("#2e3a59")
    static let slate = UIColor("#586179")
    static let paleGrey = UIColor("#f8f8fa")
    static let JRPrimary = UIColor("#00a03f")
    static let silver = UIColor("#cbcfd8")
}

extension Color {
    static let lightGray = Color(.lightGray)
    static let darkGreyBlue = Color(.darkGreyBlue)
    static let slate = Color(.slate)
    static let paleGrey = Color(.paleGrey)
    static let JRPrimary = Color(.JRPrimary)
    static let silver = Color(.silver)
}

extension UIColor {
    convenience init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let alpha, red, green, blue: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha) / 255)
    }
}
