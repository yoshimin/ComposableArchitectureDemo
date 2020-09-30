//
//  RootCore.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/25.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct RootState: Equatable {
    var login: LoginState? = LoginState()
    var home: HomeState?
}

enum RootAction: Equatable {
    case login(LoginAction)
    case home(HomeAction)
}

struct RootEnvironment {
    var loginClient: LoginClient
    var homeClient: HomeClient
    var detailClient: DetailClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    loginReducer
        .optional()
        .pullback(
            state: \.login,
            action: /RootAction.login,
            environment: {
                LoginEnvironment(loginClient: $0.loginClient, mainQueue: $0.mainQueue)
            }
        ),
    homeReducer
        .optional()
        .pullback(
            state: \.home,
            action: /RootAction.home,
            environment: {
                HomeEnvironment(homeClient: $0.homeClient, detailClient: $0.detailClient, mainQueue: $0.mainQueue)
            }
        ),
    Reducer { state, action, _ in
        switch action {
        case let .login(.loginResponse(.success(user))):
            state.home = HomeState(user: user)
            state.login = nil
            return .none
            
        case .login:
          return .none
            
        case .home(.logout):
            state.home = nil
            state.login = LoginState()
            return .none
            
        case .home:
            return .none
        }
    }
)
