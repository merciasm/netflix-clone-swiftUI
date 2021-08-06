//
//  User.swift
//  NetflixClone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia Maguerroski. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    let email: String
    let firstName: String
    let lastName: String
}
