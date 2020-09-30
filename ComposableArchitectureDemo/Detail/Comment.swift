//
//  Comment.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

extension Comment: Equatable {}
extension Comment: Identifiable {}
