//
//  ProjectRepository.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 14/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProjectRepository {

    var projectsSubject = BehaviorSubject<[Project]>(value: [])

    func fetchProjects() {
        ProjectAPIManager.FetchProjects().request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
            case .success(let projects):
                self.projectsSubject.onNext(projects)
            }
        }
    }
}
