//
//  Post.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/28.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation

struct Post: Decodable {
    private var _isFavorite: Bool?
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    var isFavorite: Bool {
        get {
            return _isFavorite ?? false
        }
        set {
            _isFavorite = newValue
        }
    }
}

extension Post: Hashable {}
extension Post: Equatable {}
extension Post: Identifiable {}
