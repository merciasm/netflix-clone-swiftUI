//
//  AppDelegate.swift
//  netflix-clone
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import SwiftUI

var appDelegate: AppDelegate {
    // swiftlint:disable:next force_cast
    return UIApplication.shared.delegate as! AppDelegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?
    var rootRouter: RootRouter!
    var userRepository = UserRepository()

    // swiftlint:disable:next force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate

    // MARK: Life cycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        //  
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        //
    }

    // MARK: Actions

    @ViewBuilder
    func presentInitialView()  -> some View {
        rootRouter = RootRouter.initModule(userRepository: userRepository)
        return rootRouter.showInitialView()
    }

    // MARK: - Setup

    private func setupLogger() {
        APILogger.shared.level = .off
        APILogger.shared.startLogging()
    }
}
