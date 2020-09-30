//
//  ComposableArchitectureDemoApp.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/30.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableArchitectureDemoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(
                initialState: RootState(),
                reducer: rootReducer.debug(),
                environment: RootEnvironment(
                    loginClient: .live,
                    homeClient: .live,
                    detailClient: .live,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            ))
        }
    }
}
