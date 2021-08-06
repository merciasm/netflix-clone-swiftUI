//
//  TextView.swift
//  netflix-clone
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Mércia All rights reserved.
//

import SwiftUI

struct TextView: View {
    let textColor: Color
    let text: String
    let size: CGFloat
    let weight: Font.FontWeight
    let alignment: TextAlignment

    var body: some View {
        Text(text)
            .font(.getPrimaryFont(size: size, weight: weight))
            .foregroundColor(textColor)
            .multilineTextAlignment(alignment)
    }
}
