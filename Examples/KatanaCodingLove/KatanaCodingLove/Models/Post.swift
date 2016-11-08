//
//  Post.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//
import UIKit

struct Post: Equatable {
    let title: String
    let image: UIImage
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.title == rhs.title &&
            lhs.image == rhs.image
    }
    
}
