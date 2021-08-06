//
//  Optional.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation

extension Optional {
    func convertNilToNull() -> Any {
        return self == nil ? NSNull() : self!
    }
}

extension Optional where Wrapped == String {
    func convertNilToEmptyString() -> Any {
        return self == nil ? "" : self!
    }
}
