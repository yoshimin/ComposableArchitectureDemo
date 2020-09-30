//
//  HomeCore.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/28.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct HomeState: Equatable {
    let user: User
    var posts: [Post] = []
    var selection: Identified<Post, DetailState?>?
    var setting: SettingState?
    var isSheetPresented = false
    var needLogout = false
}

enum HomeAction: Equatable {
    case onAppear
    case homeResponse(Result<[Post], HomeClient.Failure>)
    case setNavigation(selection: Post?)
    case detail(DetailAction)
    case logout
    case setting(SettingAction)
    case setSheet(isPresented: Bool)
}

struct HomeEnvironment {
    var homeClient: HomeClient
    var detailClient: DetailClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment>.combine(
    detailReducer
        .optional()
        .pullback(state: \Identified.value, action: .self, environment: { $0 })
        .optional()
        .pullback(
            state: \.selection,
            action: /HomeAction.detail,
            environment: {
                DetailEnvironment(detailClient: $0.detailClient, mainQueue: $0.mainQueue)
            }
        ),
    settingReducer
        .optional()
        .pullback(
            state: \.setting,
            action: /HomeAction.setting,
            environment: { _ in SettingEnvironment() }
        ),
    Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, env in
        struct CancelId: Hashable {}
        
        switch action {
        case .onAppear:
            return env.homeClient
                .fetch(HomeRequest(userId: state.user.id))
                .receive(on: env.mainQueue)
                .catchToEffect()
                .map(HomeAction.homeResponse)
            
        case let .homeResponse(.failure(error)):
            return .none
            
        case let .homeResponse(.success(posts)):
            state.posts = posts
            return .none
            
        case let .setNavigation(selection: .some(post)):
            state.selection = Identified(DetailState(post: post), id: post)
            return .none
            
        case .setNavigation(selection: .none):
            if let post = state.selection?.value?.post,
               let index = state.posts.firstIndex(where: { $0.id == post.id }) {
                state.posts[index] = post
            }
            state.selection = nil
            return .cancel(id: CancelId())
        
        case .detail:
            return .none
            
        case .logout:
            return .none
            
        case .setSheet(isPresented: true):
            state.isSheetPresented = true
            state.setting = SettingState(user: state.user)
            return .none
            
        case .setSheet(isPresented: false):
            state.isSheetPresented = false
            return .none
            
        case .setting(.logoutButtonTapped):
            state.needLogout = true
            state.isSheetPresented = false
            return .none
            
        case .setting(.onDisappear):
            state.setting = nil
            if state.needLogout {
                return Effect(value: .logout)
            }
            return .none
        }
    }
)
