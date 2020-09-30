//
//  LoginCore.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/25.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct LoginState: Equatable {
    var userId: String = ""
    var isFormValid: Bool = false
    var alert: AlertState<LoginAction>?
}

enum LoginAction: Equatable {
    case userIdChanged(String)
    case loginButtonTapped
    case loginResponse(Result<User, LoginClient.Failure>)
    case alertDismissed
}

struct LoginEnvironment {
  var loginClient: LoginClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment> { state, action, env in
    switch (action) {
    case let .userIdChanged(id):
        state.userId = id
        guard let _ = Int(id) else {
            state.isFormValid = false
            return .none
        }
        state.isFormValid = id.count > 0 && id.count <= 10
        return .none
        
    case .loginButtonTapped:
        return env.loginClient
            .login(LoginRequest(userId: state.userId))
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(LoginAction.loginResponse)
        
    case let .loginResponse(.failure(error)):
        state.alert = .init(
            title: "Error",
            message: error.message,
            dismissButton: .default("OK")
        )
        return .none
        
    case let .loginResponse(.success(user)):
        return .none
        
    case .alertDismissed:
        return .none
    }
}

private extension LoginClient.Failure {
    var message: LocalizedStringKey {
        switch self {
        case .unknownUser: return "User Not Found."
        case .internalError: return "Login failed for user."
        }
    }
}
