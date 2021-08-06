//
//  BoardRepository.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 12/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import RxSwift
import RxCocoa

class BoardRepository {

    var boardSubject = BehaviorSubject<[Task]>(value: [])

    func fetchPersonalBoard() {
        BoardAPIManager.FetchPersonalBoard().request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
            case .success(let tasks):
                self.boardSubject.onNext(tasks)
            }
        }
    }
}
