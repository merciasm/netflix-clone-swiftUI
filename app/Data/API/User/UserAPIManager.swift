//
//  UserAPIManager.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation
import Alamofire

final class UserAPIManager {
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
            let user: User
        }

        init(requestBody: RequestBody) {
            parameters = requestBody.asParameters
            guard let token = SessionHelper.shared.authToken else {
                headers = HTTPHeaders()
                return
            }
            headers = ["Authorization": "Token \(token)"]
        }
    }
}
