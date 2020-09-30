//
//  SettingCore.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/30.
//

import Foundation
import ComposableArchitecture

struct SettingState: Equatable {
    let user: User
}

enum SettingAction: Equatable {
    case logoutButtonTapped
    case onDisappear
}

struct SettingEnvironment {}

let settingReducer = Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, _ in
    switch action {
    case .logoutButtonTapped:
        return .none
    case .onDisappear:
        return .none
    }
}
