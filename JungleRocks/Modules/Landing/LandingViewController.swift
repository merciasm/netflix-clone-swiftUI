//
//  LandingViewController.swift
//  netflix-clone
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import SwiftUI

class LandingViewController: UIViewController, StoryboardLoadable {

    // MARK: Static

    static func initModule() -> LandingViewController {
        let viewController = loadFromStoryboard()
        return viewController
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func presentSwiftUIView(_ sender: Any) {
        let login = MainView(userRepository: UserRepository())
        let host = UIHostingController(rootView: login)

        // Adding swiftUI presenting
//        present(host, animated: true, completion: nil)

//
//        /// Adding the SwiftUI as a child view
//
        addChild(host)
        host.view.frame = self.view.bounds
        self.view.addSubview(host.view)
        host.didMove(toParent: self)
    }

}
