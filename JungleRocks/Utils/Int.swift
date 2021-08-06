//
//  Int.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 08/06/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Foundation

extension Int {
    func getTimeSpentString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600)/60
        let timeSpentString: String = "\(hours > 0 ? "\(hours)h" : "") \(minutes > 0 ? "\(minutes)m" : "")"
        return timeSpentString
    }
}
