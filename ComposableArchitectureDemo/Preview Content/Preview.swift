//
//  Preview.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import Foundation

struct Preview {
    static func mock<T: Decodable>(forResource name: String?, ofType ext: String?) -> T {
        let path = Bundle.main.path(forResource: name, ofType: ext)
        let url = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: url)
        let mock = try? JSONDecoder().decode(T.self, from: data!)
        return mock!
    }
}
