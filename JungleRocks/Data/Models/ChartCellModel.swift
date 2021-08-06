//
//  ChartCellModel.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//
import SwiftUI

struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    let value: CGFloat
    let name: String
}
