//
//  TaskCardView.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import SwiftUI
import Kingfisher

struct TaskCardView: View {
    let taskName: String
    let taskImage: String
    let totalTaskNumber: Int
    let workLogTime: Int
    var body: some View {

        HStack {
            Rectangle()
                .frame(height: 85)
                .frame(width: 4)
            HStack(alignment: .center) {
                HStack(spacing: 30) {
                    KFImage(URL(string: taskImage))
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(50)
                    VStack(alignment: .leading) {
                        TextView(textColor: .darkGreyBlue, text: taskName, size: 14, weight: .medium, alignment: .leading)
                        let taskString = totalTaskNumber > 1 ? "tasks" : "task"
                        TextView(textColor: .lightGray, text: "\(totalTaskNumber) \(taskString)", size: 12, weight: .regular, alignment: .leading)
                    }
                }

                Spacer()
                TextView(textColor: .darkGreyBlue, text: workLogTime.getTimeSpentString(), size: 14, weight: .medium, alignment: .trailing)
            }
            .padding(.vertical, 24.0)
            .padding(.trailing, 16.0)
            .padding(.leading, 16.0)
        }
        .background(Color.white)
        .cornerRadius(4)
        .frame(height: 80)
    }

}
