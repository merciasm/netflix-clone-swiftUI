//
//  JRUser.swift
//  junglerocks-ios
//
//  Created by Arthur Sady on 10/07/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation

struct JRUser: Codable {
    var id: Int
    let email: String
    let firstName: String
    let lastName: String
}
