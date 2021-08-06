//
//  Task.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 12/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Foundation

struct Task: Codable {
    let summary: String
    let key: String
    let status: TaskStatus
    let components: [Component]
    let storyPoints: Int?

    enum TaskStatus: String, Codable {
        case todo = "to_do"
        case inProgress = "in_progress"
        case inReview = "in_review"
        case done = "done"

        var text: String {
            switch self {
            case .todo:
                return "To do"
            case .inProgress:
                return "In Progress"
            case .inReview:
                return "In Review"
            case .done:
                return "Done"
            }
        }
    }

    struct Component: Codable {
        let name: String
    }
}
