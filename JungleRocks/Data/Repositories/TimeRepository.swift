//
//  TimeRepository.swift
//  junglerocks-ios
//
//  Created by Pedro Freddi on 07/08/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TimeRepository {

    var worklogsSubject = BehaviorSubject<[Worklog]>(value: [])

    func fetchWorklogs() {
        TimeAPIManager.FetchWorkLogs().request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
            case .success(let worklogs):
                self.worklogsSubject.onNext(worklogs)
            }
        }
    }

    func postWorklog(requestBody: TimeAPIManager.PostWorkLog.RequestBody, onSuccess: ((Worklog) -> Void)? = nil, onError: @escaping (APIError) -> Void) {
        TimeAPIManager.PostWorkLog(requestBody: requestBody).request { result in
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
                onError(error)
            case .success(let worklog):
                print(worklog)
                onSuccess?(worklog)
            }

        }
    }
}
