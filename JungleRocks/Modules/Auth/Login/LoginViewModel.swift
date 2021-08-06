//
//  LoginViewModel.swift
//  netflix-clone
//
//  Created by Arthur Sady on 05/06/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import RxSwift
import SwiftUI

enum TextFieldState {
    case valid(text: String?)
    case invalid(text: String?, error: String)
    case empty
}

enum ButtonState {
    case disabled(title: String?, icon: UIImage? = nil)
    case enabled(title: String, icon: UIImage? = nil)
}

typealias EmailFieldState = TextFieldState
typealias PasswordFieldState = TextFieldState

extension ObserverType where Element == Void {
    public func onNext() {
        onNext(())
    }
}

class LoginViewModel: Identifiable, ObservableObject {

    init(email: String? = "Some Text", password: String? = nil) {
        onEmailChange(newEmail: email)
        onPasswordChange(newPassword: password)
    }

    // MARK: Variables

    private var email: String?
    private var password: String?
    var emailSubject = BehaviorSubject<EmailFieldState>(value: .empty)
    var passwordSubject = BehaviorSubject<PasswordFieldState>(value: .empty)
    var loginButtonStateSubject = BehaviorSubject<ButtonState>(value: .disabled(title: "Login"))

    let navigateToCoreScreenSubject = PublishSubject<Void>()
    let showLoginErrorSubject = PublishSubject<(title: String, body: String)>()

    @Published var showLoginErrorText: String? = ""
    @Published var showLoginError = false

    @Published var isLoginLoading = false
    @Published var isValidFields = false
    @Published var signedIn = false

    // MARK: Public

    func onLoginButtonClick() {
        guard let email = email, let password = password else {
            // TODO handle error case
            return
        }
        isLoginLoading = true
        signedIn = false
        JRAuthAPIManager.Login(requestBody: JRAuthAPIManager.Login.RequestBody(email: email, password: password)).request { [weak self] (result) in
            guard let self = self else { return }
            self.isLoginLoading = false
            switch result {
            case .success(let response):
                // TODO replace SessionHelper with UserRepository
                self.signedIn = true
                SessionHelper.shared.createSession(
                    user: User(
                        id: response.user.id,
                        email: response.user.email,
                        firstName: response.user.firstName,
                        lastName: response.user.lastName
                ), token: response.key)
                self.navigateToCoreScreenSubject.onNext()
            case .failure(let error):
                self.signedIn = false
                self.showLoginError = true
                self.showLoginErrorText = error.localizedDescription
                self.showLoginErrorSubject.onNext((title: "Login Error", body: error.localizedDescription))
            }
        }
    }

    func onEmailChange(newEmail: String?) {
        if newEmail != email {
            email = newEmail
            emailSubject.onNext(getEmailFieldState(for: email))
            loginButtonStateSubject.onNext(getLoginButtonFieldState())
            isValidFields = validateFields()
        }
    }

    func onPasswordChange(newPassword: String?) {
        if newPassword != password {
            password = newPassword
            passwordSubject.onNext(getPasswordFieldState(for: password))
            loginButtonStateSubject.onNext(getLoginButtonFieldState())
            isValidFields = validateFields()
        }
    }

    // MARK: Private

    func validateFields() -> Bool {
        return validatePassword() && validateEmail()
    }

    func validatePassword() -> Bool {
        switch getPasswordFieldState(for: password) {
        case .valid:
            return true
        default:
            return false
        }
    }

    func validateEmail() -> Bool {
        switch getEmailFieldState(for: email) {
        case .valid:
            return true
        default:
            return false
        }
    }

    func getPasswordFieldState(for password: String?) -> PasswordFieldState {
        guard let newPassword = password,
            !newPassword.isEmpty else {
                return .empty
        }
        return .valid(text: newPassword)
    }

    func getEmailFieldState(for email: String?) -> EmailFieldState {
        if email?.isValidEmail() == true {
            return .valid(text: email)
        } else {
            return .invalid(text: email, error: "Invalid email")
        }
    }

    func getLoginButtonFieldState() -> ButtonState {
        if validateFields() {
            return .enabled(title: "Login")
        } else {
            return .disabled(title: "Login")
        }
    }
}
