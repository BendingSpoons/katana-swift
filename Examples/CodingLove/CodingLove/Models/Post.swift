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
    let imageData: Data
    
    init(title: String, imageData: Data) {
        self.title = title
        self.imageData = imageData
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.title == rhs.title &&
            lhs.imageData == rhs.imageData
    }
    
}
