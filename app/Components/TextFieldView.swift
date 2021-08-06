//
//  TextFieldView.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Mércia. All rights reserved.
//

import SwiftUI

protocol TextFieldAction {
    func onTextChange(text: String)
}

struct TextFieldView: View {
    let image: String
    let placeholder: String
    var action: (_: String) -> Void

    @State var text: String = ""

    var body: some View {
        HStack {
            Image(image)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text, onEditingChanged: { _ in
                action(text)
                print(text)
            }).autocapitalization(.none)
            .font(.getPrimaryFont(size: 14, weight: .regular))
        }
        .padding(.all, 16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.silver, lineWidth: 1)
        )
        .frame(maxWidth: .infinity)

    }
}
