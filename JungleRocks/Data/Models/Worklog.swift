//
//  Worklog.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 07/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import UIKit

struct Worklog: Codable, Identifiable {
    let id: Int?
    let category: String
    let workedAt: String?
    let timeSpent: Int
    let createdAt: Date
    let author: Author?
    let issue: Issue?

    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.calendar = Calendar.current
        formatter.locale = .current
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }

    func getTimeSpent() -> String {
        timeSpent.getTimeSpentString()
    }
}

struct Issue: Codable {
    let id: Int?
    let key: String?
    let projectKey: String?
    let sprint: Int?
    let components: [String]?
}
struct Author: Codable {
    let id: Int
    let name: String
}
