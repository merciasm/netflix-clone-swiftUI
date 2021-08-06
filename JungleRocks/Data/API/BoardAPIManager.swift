//
//  BoardAPIManager.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 12/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Alamofire

final class BoardAPIManager {
    struct FetchPersonalBoard: APIRequestable {
        typealias APIResponse = [Task]
        var method: HTTPMethod = .get
        var parameters: Parameters?
        var url = Constants.Endpoints.personalBoard
    }
}
