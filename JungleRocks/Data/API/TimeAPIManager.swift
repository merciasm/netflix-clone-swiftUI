//
//  TimeAPIManager.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 07/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

final class TimeAPIManager {
    struct FetchWorkLogs: APIRequestable {
        typealias APIResponse = [Worklog]
        var method: HTTPMethod = .get
        var parameters: Parameters?
        var url = Constants.Endpoints.worklogs
    }

    struct PostWorkLog: APIRequestable {
        typealias APIResponse = Worklog
        var method: HTTPMethod = .post
        var parameters: Parameters?
        var url = Constants.Endpoints.worklogs
        var apiLoggerLevel: APILoggerLevel = .debug

        struct RequestBody: Codable {
            let category: String
            let timeSpent: Int // seconds
            let workedAt: String
        }

        init(requestBody: RequestBody) {
            parameters = requestBody.asParameters
        }
    }
}
