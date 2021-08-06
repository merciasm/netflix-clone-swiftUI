//
//  Constants.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation

enum Constants {
    enum BaseURL {
        static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String // swiftlint:disable:this force_cast
        static var baseURLHost: String {
            return self.baseURL
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
        }
    }

    enum Endpoints {
        private enum Version: String, CaseIterable {
            case v1, v2
        }

        static private func getEndpointURL(_ version: Version, _ endpoint: String) -> String {
            return BaseURL.baseURL + "/api/" + version.rawValue + endpoint
        }

        static func getPath(forEndpoint endpoint: String) -> String {
            var result = endpoint
            for version in Version.allCases {
                result = result.replacingOccurrences(of: BaseURL.baseURL + "/api/" + version.rawValue, with: "")
            }
            return result
        }

        // MARK: Auth

        static var login: String { return getEndpointURL(.v1, "/login/") }
    }


    static let exampleMovie1 = Movie(id: UUID().uuidString, name: "DARK", thumbnailURL: URL(string: "https://picsum.photos/200/300")!)


}
