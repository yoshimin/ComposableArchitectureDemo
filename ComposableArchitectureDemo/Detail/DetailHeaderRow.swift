//
//  DetailHeaderRow.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI

struct DetailHeaderRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(post.body)
                .font(.body)
        }
    }
}

struct DetailHeaderRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeaderRow(post: Preview.mock(forResource: "post", ofType: "json"))
        .frame(width: 500)
        .previewLayout(.sizeThatFits)
    }
}
