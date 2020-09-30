//
//  DetailClient.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation
import ComposableArchitecture

struct DetailRequest {
    let postId: Int
}

struct DetailClient {
    struct Failure: Error, Equatable {}
    
    var fetchComments: (DetailRequest) -> Effect<[Comment], Failure>
}

extension DetailClient {
    static let live = DetailClient { request in
        var url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(request.postId)")!

        return URLSession.shared.dataTaskPublisher(for: url)
          .map { data, _ in data }
          .decode(type: [Comment].self, decoder: JSONDecoder())
          .mapError { _ in Failure() }
          .eraseToEffect()
    }
    
    static let mock = DetailClient { _ in
        return Effect(value: Preview.mock(forResource: "comments", ofType: "json"))
    }
}
