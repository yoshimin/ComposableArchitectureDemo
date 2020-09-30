//
//  PostRow.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/28.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI

struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                Text(post.isFavorite ? "★ " : "")
                    .font(.title)
                    .foregroundColor(.blue) +
                Text(post.title)
                    .font(.title)
            }
            .layoutPriority(1)
            Text(post.body)
                .font(.caption)
                .lineLimit(2)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
    }
}

struct PostRow_Previews: PreviewProvider {
    private static var post: Post = Preview.mock(forResource: "post", ofType: "json")
    private static var favoritePost: Post {
        post.isFavorite = true
        return post
    }
    static var previews: some View {
        PostRow(post: post)
        .frame(width: 500)
        .previewLayout(.sizeThatFits)
        
        PostRow(post: favoritePost)
        .frame(width: 500)
        .previewLayout(.sizeThatFits)
    }
}
