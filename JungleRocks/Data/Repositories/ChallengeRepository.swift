//
//  ChallengeRepository.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 05/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import RxSwift
import RxCocoa

class ChallengeRepository {

    var challengeSubject = BehaviorSubject<[Challenge]>(value: [])

    func fetchChallenges() {
        LearningAPIManager.FetchChallenges().request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
            case .success(let challenges):
                self.challengeSubject.onNext(challenges)
            }
        }
    }
}
