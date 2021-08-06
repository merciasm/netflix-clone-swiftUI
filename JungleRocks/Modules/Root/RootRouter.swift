//
//  RootRouter.swift
//  netflix-clone
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import SwiftUI

final class RootRouter {

    // MARK: Static

    static func initModule(userRepository: UserRepository) -> RootRouter {
        let router = RootRouter()
        router.userRepository = userRepository
        return router
    }

    // MARK: - Properties

    var userRepository: UserRepository!
    let boardRepository = BoardRepository()
    let timeRepository = TimeRepository()
    let projectRepository = ProjectRepository()

    // MARK: Actions

    @ViewBuilder
    func showInitialView() -> some View {
        if SessionHelper.shared.isUserLogged {
            let timeViewModel = TimeViewModel(timeRepository: timeRepository, projectRepository: projectRepository)
            BoardView(timeViewModel: timeViewModel)
        } else {
            LoginView()
        }
    }

    func presentLandingScreen() {
            let landingViewController = LandingViewController.initModule()
            presentAsRoot(landingViewController)
        }

}

private extension RootRouter {
    func presentAsRoot(_ viewController: UIViewController) {
        guard let window = appDelegate.window else { return }
        window.backgroundColor = .white
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
    }
}

enum Route {
    case login
    case board
}
