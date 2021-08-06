//
//  ProjectAPIManager.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 14/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import Alamofire

final class ProjectAPIManager {
    struct FetchProjects: APIRequestable {
        typealias APIResponse = [Project]
        var method: HTTPMethod = .get
        var parameters: Parameters?
        var url = Constants.Endpoints.projects
    }
}
