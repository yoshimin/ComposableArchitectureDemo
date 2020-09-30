//
//  CommentRow.swift
//  ComposableArchitectureDemo
//
//  Created by Yoshimi Shingai on 2020/09/29.
//  Copyright © 2020 Yoshimi Shingai. All rights reserved.
//

import SwiftUI

struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(comment.name)
                .font(.headline)
            Text(comment.body)
                .font(.body)
            Divider()
        }
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(
            comment: Comment(
                postId: 1,
                id: 1,
                name: "id labore ex et quam laborum",
                email: "Eliseo@gardner.biz",
                body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
            ))
            .frame(width: 500)
            .previewLayout(.sizeThatFits)
    }
}
