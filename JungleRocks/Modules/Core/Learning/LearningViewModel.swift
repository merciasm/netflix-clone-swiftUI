//
//  LearningViewModel.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 05/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Foundation
import RxSwift

// TODO: Create the challenges categories 
class LearningViewModel {
    init(repository: ChallengeRepository) {
        self.repository = repository
        self.fetchChallenges()
        challengeList.subscribe(onNext: { [weak self] challenges in
            let dict = Dictionary(grouping: challenges, by: { challenge in challenge.stack.name })
            let sectionList: [LearningViewModel.Section] = dict.keys.compactMap { (key) in
                guard let challenges = dict[key] else { return nil }
                return (key, challenges)
            }
            self?.challengeDictSubject.onNext(sectionList)
            }).disposed(by: disposeBag)
    }

    typealias Section = (title: String, challenges: [Challenge])
    private let disposeBag = DisposeBag()
    private let repository: ChallengeRepository

    private var challengeList: Observable<[Challenge]> {
        return repository.challengeSubject
    }
    let challengeDictSubject = BehaviorSubject<[LearningViewModel.Section]>(value: [])

    func fetchChallenges() {
        repository.fetchChallenges()
    }
}
