//
//  User.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/25.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation

struct User: Decodable {
    struct Address: Decodable {
        struct Geo: Decodable {
            let lat: String
            let lng: String
        }
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: Geo
    }
    struct Company: Decodable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
