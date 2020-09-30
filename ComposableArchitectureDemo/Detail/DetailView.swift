//
//  DetailView.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    struct ViewState {
        var favoriteButtonColor: Color
    }
    
    let store: Store<DetailState, DetailAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    DetailHeaderRow(post: viewStore.post)
                    Text("Comments")
                        .padding(.vertical)
                        .font(.title)
                    ForEach(viewStore.comments) { comment in
                        CommentRow(comment: comment)
                    }
                }
                .padding()
            }
            .navigationBarItems(
                trailing: Button(action: {
                    viewStore.send(.favoriteButtonTapped)
                }, label: {
                    Text("★")
                        .foregroundColor(viewStore.view.favoriteButtonColor)
                })
            )
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

extension DetailState {
    var view: DetailView.ViewState {
        DetailView.ViewState(
            favoriteButtonColor: post.isFavorite ? .blue : .gray
        )
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(store: Store<DetailState, DetailAction>(
            initialState: DetailState(post: Preview.mock(forResource: "post", ofType: "json")),
            reducer: detailReducer,
            environment: DetailEnvironment(
                detailClient: .mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
        .previewDevice("iPhone 11")
    }
}
