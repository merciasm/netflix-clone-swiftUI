//
//  AuthenticationAPIManager.swift
//  junglerocks-ios
//
//  Created by Arthur Sady on 10/07/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

final class JRAuthAPIManager {
    struct Login: APIRequestable {
        typealias APIResponse = ResponseBody
        var method: HTTPMethod = .post
        var parameters: Parameters?
        var url: String = Constants.Endpoints.login
        var headers: HTTPHeaders?
        var logoutIfUnauthorized: Bool = false
        var apiLoggerLevel: APILoggerLevel = .debug

        struct RequestBody: Codable {
            let email: String
            let password: String
        }

        struct ResponseBody: Codable {
            let key: String
            let user: JRUser
        }

        init(requestBody: RequestBody) {
            parameters = requestBody.asParameters
        }
    }
}
