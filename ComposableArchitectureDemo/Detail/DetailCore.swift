//
//  DetailCore.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct DetailState: Equatable {
    var post: Post
    var comments: [Comment] = []
}

enum DetailAction: Equatable {
    case onAppear
    case detailResponse(Result<[Comment], DetailClient.Failure>)
    case favoriteButtonTapped
}

struct DetailEnvironment {
    var detailClient: DetailClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, env in
    switch action {
    case .onAppear:
        return env.detailClient
            .fetchComments(DetailRequest(postId: state.post.id))
            .receive(on: env.mainQueue)
            .catchToEffect()
            .map(DetailAction.detailResponse)
        
    case let .detailResponse(.failure(error)):
        return .none
        
    case let .detailResponse(.success(comments)):
        state.comments = comments
        return .none
        
    case .favoriteButtonTapped:
        state.post.isFavorite.toggle()
        return .none
    }
}
