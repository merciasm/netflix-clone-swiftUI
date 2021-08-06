//
//  BoardView.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 29/03/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import SwiftUI

struct BoardView: View {
    @State private var didTapToFilter: Bool = false
    @State var selection: Int = 0
    @State var isNavigationBarHidden: Bool = true
    @ObservedObject var timeViewModel: TimeViewModel
    @State var navigateToLogScreen = false
    @State var navigateToViewController = false

    var body: some View {
        ZStack {
            ScrollView(
                [.vertical],
                showsIndicators: false
            ) {
                VStack(alignment: .leading, spacing: 32.0) {
                    VStack(alignment: .center, spacing: 48.0) {
                        VStack(alignment: .leading, spacing: 16.0) {
                            ///Code to test the navigation
//                            NavigationLink(destination: Landing(), isActive: $navigateToViewController) {
//                                Button(action: {
//                                    navigateToViewController = true
//                                }) {
//                                    ZStack {
//                                        Image(systemName: "stop")
//                                    }
//                                    .padding(.all, 7)
//                                    .background(Color.slate)
//                                    .shadow(radius: 8)
//                                    .cornerRadius(28)
//                                    .frame(width: 56, height: 56)
//                                }
//
//                            }
                            TextView(textColor: .darkGreyBlue, text: "Time tracking", size: 16, weight: .medium, alignment: .leading)
                            FiltersButtons(selection: $selection)
                        }

                        DonutChart(dataModel: ChartDataModel.init(dataModel: timeViewModel.chartTime))
                            .frame(width: 144, height: 144)
                    }
                    .padding(0.0)

                    VStack(alignment: .leading, spacing: 24.0) {
                        VStack(alignment: .leading) {
                            HStack {
                                TextView(textColor: .lightGray, text: "Projects", size: 14, weight: .medium, alignment: .leading)
                                Spacer()
                                TextView(textColor: .darkGreyBlue, text: timeViewModel.projectTimeSpent, size: 14, weight: .medium, alignment: .trailing)

                            }

                            ForEach(timeViewModel.projectActivitiesList, id: \.id) { project in
                                let totalTime = project.worklogs.reduce(0, { accumulatedResult, worklog -> Int in
                                    return (accumulatedResult + worklog.timeSpent)
                                })
                                TaskCardView(taskName: project.project.name, taskImage: project.project.image ?? "", totalTaskNumber: project.worklogs.count, workLogTime: totalTime)
                                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                                        .padding(.trailing, 1)
                                        .padding(.top, 16)
                                }

                        }

                        HStack {
                            TextView(textColor: .lightGray, text: "Other activities", size: 14, weight: .medium, alignment: .leading)
                            Spacer()
                            TextView(textColor: .darkGreyBlue, text: timeViewModel.activityTimeSpent, size: 14, weight: .medium, alignment: .trailing)
                        }

                        ForEach(timeViewModel.otherActivitiesList, id: \.id) { activity in
                            let totalTime = activity.worklogs.reduce(0, { accumulatedResult, worklog -> Int in
                                return (accumulatedResult + worklog.timeSpent)
                            })

                            TaskCardView(taskName: activity.type, taskImage: "", totalTaskNumber: activity.worklogs.count, workLogTime: totalTime)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                                .padding(.trailing, 1)
                                .padding(.top, 16)
                        }

                        VStack {
                            TextView(textColor: .lightGray, text: "Last time logs", size: 14, weight: .medium, alignment: .leading)
                        }

                        ForEach(timeViewModel.worklogs, id: \.id) { worklog in

                            LastTimeLogView(workLog: worklog)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: LogTimeView(), isActive: self.$navigateToLogScreen) {
                        Button(action: {
                            navigateToLogScreen = true
                        }) {
                            ZStack {
                                Image("iconLogtime40Px")
                            }
                            .padding(.all, 7)
                            .background(Color.slate)
                            .shadow(radius: 8)
                            .cornerRadius(28)
                            .frame(width: 56, height: 56)
                        }
                    }
                }

            }
            if #available(iOS 14.0, *), timeViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
            } else {
                // TODO: loading spinner to ios 13
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
        }
    }
}

 struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BoardView(timeViewModel: TimeViewModel(timeRepository: TimeRepository(), projectRepository: ProjectRepository())).previewDevice("iPhone 8")
        }
    }
 }

struct FiltersButtons: View {
    init(selection: Binding<Int>) {
        self._currentlySelectedId = selection
    }
    @Binding var currentlySelectedId: Int

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            FilterButton(id: 1, currentlySelectedId: $currentlySelectedId, label: "This week")
            FilterButton(id: 2, currentlySelectedId: $currentlySelectedId, label: "Last week")
            FilterButton(id: 3, currentlySelectedId: $currentlySelectedId, label: "This month")
        }
        .frame(maxWidth: .infinity)
    }
}

// this is how a view controller is called from swiftUI
// TODO: Generalize this
struct Landing: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<Landing>) -> UIViewController {
        let landing = LandingViewController.initModule()
        return landing
    }

}
