//
//  LoginClient.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/25.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct LoginRequest {
    let userId: String
}

struct LoginClient {
    enum Failure: Error {
        case unknownUser
        case internalError
    }
    
    var login: (LoginRequest) -> Effect<User, Failure>
}

extension LoginClient {
    static let live = LoginClient(login: { request in
        var url = URL(string: "https://jsonplaceholder.typicode.com/users/\(request.userId)")!

        return URLSession.shared.dataTaskPublisher(for: url)
          .map { data, _ in data }
          .decode(type: User.self, decoder: JSONDecoder())
          .mapError {
            if let decodingError = $0 as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, _):
                    if key.stringValue == "id" { return .unknownUser }
                default: break
                }
            }
            return .internalError
          }
          .eraseToEffect()
    })
    
    static let mock = LoginClient(login: { _ in
        return Effect(value: Preview.mock(forResource: "user", ofType: "json"))
    })
}
