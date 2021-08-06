//
//  Project.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 07/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation

struct Project: Codable, Identifiable {
    var id: Int
    let name: String
    let image: String?
    let key: String
}
