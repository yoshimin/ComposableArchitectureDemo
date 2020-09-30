//
//  LoginView.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/19.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    struct ViewState: Equatable {
        var userId: String
        var cautionColor: Color
        var isLoginButtonDisabled: Bool
        var loginButtonColor: Color
    }

    let store: Store<LoginState, LoginAction>
    
    var body: some View {
        WithViewStore(store.scope(state: { $0.view })) { viewStore in
            VStack(spacing: 20) {
                Text("Login")
                    .fontWeight(.heavy)
                Text("Enter a number between 1-10")
                    .font(.caption)
                    .foregroundColor(viewStore.cautionColor)
                TextField("Enter userId...", text: viewStore.binding(get: { $0.userId }, send: LoginAction.userIdChanged))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                Button(action: {
                    viewStore.send(.loginButtonTapped)
                }, label: {
                    Text("Go")
                        .foregroundColor(viewStore.loginButtonColor)
                        .frame(width: 120, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewStore.loginButtonColor, lineWidth: 1)
                        )
                })
                .disabled(viewStore.isLoginButtonDisabled)

            }
            .alert(
              self.store.scope(state: { $0.alert }),
              dismiss: .alertDismissed
            )
        }
    }
}

extension LoginState {
  var view: LoginView.ViewState {
    LoginView.ViewState(
        userId: userId,
        cautionColor: userId.count > 0 && !isFormValid ? .red : .primary,
        isLoginButtonDisabled: !isFormValid,
        loginButtonColor: isFormValid ? .blue : .gray
    )
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: Store(
            initialState: LoginState(),
            reducer: loginReducer,
            environment: LoginEnvironment(
                loginClient: .mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
    }
}

