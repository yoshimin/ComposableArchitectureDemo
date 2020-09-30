//
//  SettingView.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/30.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    let store: Store<SettingState, SettingAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Form {
                    Section(header: mapView(viewStore).frame(height: 180)) {
                        EmptyView()
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("phone").font(.callout)
                        Text(viewStore.user.phone)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("email").font(.callout)
                        Text(viewStore.user.email)
                    }
                    Section(header: Text("company")) {
                        Text(viewStore.user.company.name)
                        Text(viewStore.user.company.catchPhrase)
                    }
                    Section {
                        Button(action: {
                            viewStore.send(.logoutButtonTapped)
                        }, label: {
                            Text("Logout")
                                .foregroundColor(.red)
                        })
                    }
                }
                .navigationTitle(Text(viewStore.user.name))
                .onDisappear { viewStore.send(.onDisappear) }
            }
        }
    }
    
    func mapView(_ viewStore: ViewStore<SettingState, SettingAction>) -> MapView {
        MapView(latitude: Double(viewStore.user.address.geo.lat)!,
                longitude: Double(viewStore.user.address.geo.lng)!)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(store: Store(
                        initialState: SettingState(user: Preview.mock(forResource: "user", ofType: "json")),
                        reducer: settingReducer,
                        environment: SettingEnvironment()))
    }
}
