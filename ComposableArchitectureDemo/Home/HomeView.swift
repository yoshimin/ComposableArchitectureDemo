//
//  HomeView.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/28.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @State var isPresented: Bool = false
    let store: Store<HomeState, HomeAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List(viewStore.posts) { post in
                ZStack(alignment: .leading) {
                    PostRow(post: post)
                    NavigationLink(
                        destination: IfLetStore(
                            store.scope(
                                state: { $0.selection?.value },
                                action: HomeAction.detail
                            ),
                            then: DetailView.init(store:)
                        ),
                        tag: post,
                        selection: viewStore.binding(
                            get: { $0.selection?.id },
                            send: HomeAction.setNavigation(selection:)
                        ),
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    viewStore.send(.setSheet(isPresented: true))
                }, label: {
                    Image(systemName: "gearshape")
                })
            )
            .sheet(isPresented:
                    viewStore.binding(
                        get: { $0.isSheetPresented },
                        send: HomeAction.setSheet(isPresented:)
                    )
            ) {
                IfLetStore(
                    store.scope(
                        state: { $0.setting },
                        action: HomeAction.setting
                    ),
                    then: SettingView.init(store:)
                )
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(
            initialState: HomeState(user: Preview.mock(forResource: "user", ofType: "json")),
            reducer: homeReducer,
            environment: HomeEnvironment(
                homeClient: .mock,
                detailClient: .mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
        .previewDevice("iPhone 11")
    }
}
