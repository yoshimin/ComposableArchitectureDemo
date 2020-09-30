//
//  HomeClient.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/28.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct HomeRequest {
    let userId: Int
}

struct HomeClient {
    struct Failure: Error, Equatable {}
    
    var fetch: (HomeRequest) -> Effect<[Post], Failure>
}

extension HomeClient {
    static let live = HomeClient(fetch: { request in
        var url = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(request.userId)")!

        return URLSession.shared.dataTaskPublisher(for: url)
          .map { data, _ in data }
          .decode(type: [Post].self, decoder: JSONDecoder())
          .mapError { _ in Failure() }
          .eraseToEffect()
    })
    
    static let mock = HomeClient(fetch: { _ in
        return Effect(value: Preview.mock(forResource: "posts", ofType: "json"))
    })
}
