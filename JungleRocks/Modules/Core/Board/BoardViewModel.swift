//
//  BoardViewModel.swift
//  netflix-clone
//
//  Created by Pedro Freddi on 12/01/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import RxSwift

class BoardViewModel: ObservableObject {

    // MARK: - Factory

    init(withRepository repository: BoardRepository) {
        self.repository = repository
        self.fetchPersonalBoard()
    }

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let repository: BoardRepository
    private var taskList: Observable<[Task]> {
        return repository.boardSubject
    }

    func fetchPersonalBoard() {
        repository.fetchPersonalBoard()
    }
}
