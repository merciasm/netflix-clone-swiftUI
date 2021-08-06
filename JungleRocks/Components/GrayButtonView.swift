//
//  GrayButtonView.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import SwiftUI

struct FilterButton: View {
    let id: Int
    @Binding var currentlySelectedId: Int
    var label: String

    var body: some View {
        Button(action: { self.currentlySelectedId = self.id }, label: {
            Text(label)
                .font(.getPrimaryFont(size: 14, weight: .medium))
        })
        .padding(.horizontal, 16)
        .padding(.vertical, 8) // 1. Add the padding
        .frame(maxWidth: .infinity)
        .background(id == currentlySelectedId ? Color.slate : Color.paleGrey) // 2. Change the background color using custom color
        .foregroundColor(id == currentlySelectedId ? Color.white : Color.slate)  // 3. Set the foreground/font color
        .cornerRadius(20)
        .multilineTextAlignment(.center)
    }
}
