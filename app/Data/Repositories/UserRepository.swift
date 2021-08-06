//
//  UserRepository.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation
import RxSwift

final class UserRepository {

    // MARK: - Variables

    var userSubject = BehaviorSubject<User?>(value: SessionHelper.shared.currentUser)

    // MARK: - Session

    var currentUser: User? {
        return try? userSubject.value()
    }

    var isUserLogged: Bool {
        return SessionHelper.shared.isUserLogged
    }

    func endSession() {
        SessionHelper.shared.endSession()
        userSubject.onNext(nil)
    }

    // MARK: - API

    func login(loginRequestBody: UserAPIManager.Login.RequestBody, onSuccess: ((User) -> Void)? = nil, onError: @escaping (APIError) -> Void) {
        UserAPIManager.Login(requestBody: loginRequestBody).request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                log.v(error)
                self.userSubject.onNext(nil)
                onError(error)
            case .success(let response):
                print(response)
                SessionHelper.shared.createSession(user: response.user, token: response.key)
                self.userSubject.onNext(response.user)
                onSuccess?(response.user)
            }
        }
    }
}
