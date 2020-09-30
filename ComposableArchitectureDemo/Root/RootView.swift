//
//  RootView.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/25.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: Store<RootState, RootAction>
    
    @ViewBuilder var body: some View {
        IfLetStore(
            store.scope(
                state: { $0.login },
                action: RootAction.login
            )
        ) { store in
            NavigationView {
                LoginView(store: store)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        
        IfLetStore(
            store.scope(
                state: { $0.home },
                action: RootAction.home
            )
        ) { store in
            NavigationView {
                HomeView(store: store)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
