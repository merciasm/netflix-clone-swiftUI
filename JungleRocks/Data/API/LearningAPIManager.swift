//
//  LearningAPIManager.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 05/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Alamofire

final class LearningAPIManager {
    struct FetchChallenges: APIRequestable {
        typealias APIResponse = [Challenge]
        var method: HTTPMethod = .get
        var parameters: Parameters?
        var url = Constants.Endpoints.challenges
    }
}
