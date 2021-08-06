//
//  Challenge.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 05/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Foundation

struct Challenge: Codable {
    let name: String
    let id: Int
    let completed: Bool
    let totalNumberOfSteps: Int
    let numberOfCompletedSteps: Int
    let stack: Stack

    struct Stack: Codable {
        let id: Int
        let image: String?
        let name: String
    }
}
