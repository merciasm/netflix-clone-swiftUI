//
//  Log.swift
//  NetflixClone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia Maguerroski. All rights reserved.
//

import Foundation

struct log {
    static func d(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        log.print(items, separator: separator, terminator: terminator)
    }

    static func v(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n",
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
        let headerMessage = "----- \(URL(fileURLWithPath: file).lastPathComponent).\(function):\(line) -----"
        let footerMessage = String(repeating: "-", count: headerMessage.count)

        log.print(["\n", headerMessage], separator: "")
        log.print(items, separator: separator, terminator: terminator)
        log.print([footerMessage, "\n"])
    }

    private static func print(_ items: [Any], separator: String = " ", terminator: String = "\n") {
        #if DEBUG

        let stringItems: [String] = items.compactMap({ "\($0)" })

        var index = stringItems.startIndex
        let endIndex = stringItems.endIndex
        repeat {
            let item: String = stringItems[index]

            Swift.print(item, separator: separator, terminator: index == (endIndex - 1) ? terminator : separator)

            index += 1
        } while index < endIndex

        #endif
    }
}
