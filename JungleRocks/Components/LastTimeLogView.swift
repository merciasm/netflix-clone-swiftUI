//
//  LastTimeLogView.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 13/05/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import SwiftUI

struct LastTimeLogView: View {
    let workLog: Worklog
    var body: some View {

        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                TextView(textColor: .darkGreyBlue, text: workLog.category.uppercased(), size: 14, weight: .medium, alignment: .trailing)
                HStack {
                    TextView(textColor: .lightGray, text: workLog.getTimeSpent(), size: 12, weight: .regular, alignment: .leading)
                    TextView(textColor: .lightGray, text: workLog.timeAgoDisplay(), size: 12, weight: .regular, alignment: .leading)
                }
            }
            Divider()
                .background(Color(red: 237, green: 239, blue: 245))
        }

    }
}
