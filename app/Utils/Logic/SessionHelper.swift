//
//  SessionHelper.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 05/08/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import Foundation

final class SessionHelper {

    // MARK: Static

    static let shared = SessionHelper()

    // MARK: Constants

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: Properties

    var authToken: String? {
        guard let data = KeychainHelper.loadData(forKey: .authToken) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    var currentUser: User? {
        guard let data = LocalStoreHelper.loadData(forKey: .user) else { return nil }
        guard let user = try? decoder.decode(User.self, from: data) else {
            log.d("Could not decode user data from local store")
            return nil
        }
        return user
    }

    var isUserLogged: Bool {
        return currentUser != nil
    }

    // MARK: Private

    func endSession() {
        LocalStoreHelper.clearLocalStore()
        KeychainHelper.clearKeychain()
    }

    // MARK: Public

    func createSession(user: User, token: String) {
        guard let userData = try? encoder.encode(user) else {
            fatalError("Could not serialize user data")
        }
        guard KeychainHelper.save(data: Data(token.utf8), forKey: .authToken) == .success else {
            fatalError("Could not save authorization token")
        }
        LocalStoreHelper.save(data: userData, forKey: .user)
    }

    func logout() {
        endSession()
    }
}
