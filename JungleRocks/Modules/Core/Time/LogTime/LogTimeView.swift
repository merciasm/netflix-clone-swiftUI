//
//  LogTimeView.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 09/06/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import SwiftUI

struct LogTimeView: View {
    @State private var didTapToFilter: Bool = false
    @State var selection: Int = 0
    @State var isNavigationBarHidden: Bool = true
    @State var descriptionText: String = ""
    @State var dateText: String = "\(Calendar.current.component(.year, from: Date()))/\(Calendar.current.component(.month, from: Date()))/\(Calendar.current.component(.day, from: Date()))"
    @State var startDate = Date()
    @State var endDate = Date()

    @ObservedObject var viewModel = LogTimeViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var closeButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image("close24Px") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.darkGreyBlue)
        }
    }

    private var startDateProxy: Binding<Date> {
        Binding<Date>(get: {self.startDate }, set: {
            self.startDate = $0
            self.viewModel.onStartDateChange(newStartDate: startDate)
        })
    }

    private var endDateProxy: Binding<Date> {
        Binding<Date>(get: {self.endDate }, set: {
            self.endDate = $0
            self.viewModel.onEndDateChange(newEndDate: endDate)
        })
    }

    private var categoryProxy: Binding<Int> {
        Binding<Int>(get: {self.selection }, set: {
            self.selection = $0

            self.viewModel.onCategorySelected(selectedCategory: getCategoryWithId(id: selection))
        })
    }

    func getCategoryWithId(id: Int) -> String {
        switch id {
        case 1:
            return Category.studies.text
        case 2:
            return Category.checkIns.text
        case 3:
            return Category.companyProcesses.text
        default:
            return ""
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 24.0) {
                Buttons(selection: categoryProxy)
                VStack(spacing: 16.0) {
                    HStack {
                        SwiftUI.TextField("Date", text: $dateText, onEditingChanged: { text in
                            print(text)

                        })
                        .disabled(true)
                        .foregroundColor(.slate)
                        .font(.getPrimaryFont(size: 14, weight: .regular))
                        Image("calendar16Px")
                            .foregroundColor(.gray)
                    }
                    .padding(.all, 16)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.silver, lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity)

                    HStack {
                        DatePicker("Start", selection: startDateProxy, displayedComponents: [.hourAndMinute])
                            .foregroundColor(.slate)
                            .font(.getPrimaryFont(size: 14, weight: .regular))
                            .accentColor(.slate)
                            .padding(.leading, 16)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.silver, lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)

                        DatePicker("End", selection: endDateProxy, displayedComponents: [.hourAndMinute])
                            .foregroundColor(.slate)
                            .font(.getPrimaryFont(size: 14, weight: .regular))
                            .accentColor(.slate)
                            .padding(.leading, 16)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.silver, lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)

                    }
                }
                Spacer()
                NavigationLink(destination: appDelegate.presentInitialView(), isActive: $viewModel.canDismissView) {
                    Button(action: {
                        viewModel.onAddClicked()
                    }) {
                        TextView(textColor: .white, text: "Add", size: 14, weight: .medium, alignment: .center)
                            .padding(.all, 12.0)

                    }.frame(maxWidth: .infinity)
                    .background(Color.slate)
                    .cornerRadius(4)
                    .opacity(viewModel.areValidFields ? 1 : 0.6)
                    .disabled(!viewModel.areValidFields)
                }
                .disabled(!viewModel.areValidFields)
            }
            .frame(maxWidth: .infinity)
            if #available(iOS 14.0, *), viewModel.isLogScreenLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
            } else {
                // TODO: loading spinner to ios 13
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarItems(leading: closeButton)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(
            Text("Log time")
                .font(.getPrimaryFont(size: 20, weight: .regular)), displayMode: .inline
        )
        .onAppear {
            self.isNavigationBarHidden = false
        }
        .alert(isPresented: $viewModel.showLogTimeError, content: {
            Alert(title: Text("Login Error"), message: Text(viewModel.logTimeError), dismissButton: .default(Text("ok")))
        })
    }
}

struct LogTimeView_Previews: PreviewProvider {
    static var previews: some View {
        LogTimeView()
    }
}

struct Buttons: View {
    init(selection: Binding<Int>) {
        self._currentlySelectedId = selection
    }
    @Binding var currentlySelectedId: Int

    var body: some View {
        HStack(spacing: 8) {
            FilterButton(id: 1, currentlySelectedId: $currentlySelectedId, label: Category.studies.text)
            FilterButton(id: 2, currentlySelectedId: $currentlySelectedId, label: Category.checkIns.text)
            FilterButton(id: 3, currentlySelectedId: $currentlySelectedId, label: Category.companyProcesses.text)
        }
        .frame(maxWidth: .infinity)
    }
}

enum Category {
    case studies, checkIns, companyProcesses

    var text: String {
        switch self {
        case .studies:
            return "Studies"
        case .checkIns:
            return "Check-ins"
        case .companyProcesses:
            return "Company Processes"
        }
    }
}
