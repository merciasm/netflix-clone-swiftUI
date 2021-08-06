//
//  Keyboard.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 26/05/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import SwiftUI

struct Keyboard: ViewModifier {
    @State var offset: CGFloat = 0
    func body(content: Content) -> some View {

       return content.padding(.bottom, offset).onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                let height = value?.height

                self.offset = height ?? 0
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.offset = 0
            }
        }
    }
}

extension View {
    func keyboardResponsive() -> some View {
        return self.modifier(Keyboard())
    }
}
