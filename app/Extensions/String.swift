//
//  String.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(with values: String...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: values)
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func createAttributedString(baseFont: UIFont,
                                subStrings: [String],
                                subStringsFont: UIFont,
                                underlineStyle: NSUnderlineStyle = NSUnderlineStyle(rawValue: 0)) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let baseRange = attributedString.mutableString.range(of: self)
        attributedString.addAttribute(NSAttributedString.Key.font, value: baseFont, range: baseRange)
        subStrings.forEach { string in
            let stringRange = attributedString.mutableString.range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.font, value: subStringsFont, range: stringRange)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: underlineStyle.rawValue, range: stringRange)
        }
        return attributedString
    }
}
