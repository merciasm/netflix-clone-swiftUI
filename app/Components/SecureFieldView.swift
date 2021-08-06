//
//  SecureFieldView.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import SwiftUI

struct SecureFieldView: View {
    let image: String
    let placeholder: String
    @State var text: String = ""
    var action: (_: String) -> Void

    var body: some View {

        HStack {
            Image(image)
            SecureField(placeholder, text: $text) {
                action(text)
            }
        }
        .padding(.all, 16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.silver, lineWidth: 1)
        )

    }
}
