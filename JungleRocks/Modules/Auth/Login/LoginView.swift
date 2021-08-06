//
//  LoginView.swift
//  junglerocks-ios
//
//  Created by Mércia Maguerroski on 19/03/21.
//  Copyright © 2021 Jungle Devs. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginView: View {

    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject private var model = LoginViewModel()
    @State var isNavigationBarHidden: Bool = true

    private let rootRouter = RootRouter()

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 75.0) {
                Spacer()
                VStack(alignment: .leading, spacing: 2.0) {
                    Image("logo48")
                    TextView(textColor: .white, text: "Welcome to", size: 16, weight: .medium, alignment: .leading)
                    TextView(textColor: .white, text: "Jungle Rocks", size: 24, weight: .medium, alignment: .leading)

                }
                .padding(.horizontal, 26)

                VStack(alignment: .leading) {
                    TextView(textColor: .gray, text: "Please login to your account", size: 16, weight: .regular, alignment: .leading)
                        .padding(.top, 40.0)
                        .padding(.horizontal, 24)

                    VStack(spacing: 16) {
                        TextFieldView(image: "email24Px", placeholder: "Email", action: model.onEmailChange(newEmail:), text: email)
                                .padding(.horizontal, 24)

                        SecureFieldView(image: "password24Px", placeholder: "Password", text: password, action: model.onPasswordChange(newPassword:))
                            .padding(.horizontal, 24)

                        Spacer()

                        NavigationLink(destination: rootRouter.showInitialView(), isActive: $model.signedIn) {
                            Button(action: {
                                model.onLoginButtonClick()
                            }) {
                                TextView(textColor: .white, text: "Login", size: 14, weight: .medium, alignment: .center)
                                    .padding(.all, 12.0)

                            }.frame(maxWidth: .infinity)
                            .background(Color.JRPrimary)
                            .cornerRadius(4)
                            .padding(.horizontal, 24)
                            .opacity(model.isValidFields ? 1 : 0.6)
                            .disabled(!model.isValidFields)
                        }
                        .labelsHidden()
                        .disabled(!model.isValidFields)
                    }.padding(.vertical, 20)
                }
                .KeyboardResponsive()
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
            }
            if #available(iOS 14.0, *), model.isLoginLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
            } else {
                // TODO: loading spinner to ios 13
            }
        }
        .background(Color.JRPrimary)
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $model.showLoginError, content: {
            Alert(title: Text("Login Error"), message: Text(model.showLoginErrorText ?? ""), dismissButton: .default(Text("ok")))
        })
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
        }
    }
}

 struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Display the code for more than one device, pretty nice, huh
            //            LoginView().previewDevice("iPhone 8")
            //            LoginView().previewDevice("iPhone 11 Pro Max")
            // But Mércia computer can't handle this :C

            LoginView().previewDevice("iPhone 8")
        }

    }
 }

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
