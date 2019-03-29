//
//  File.swift
//  LivePhotoTestApp
//
//  Created by Евгений Клебан on 3/27/19.
//  Copyright © 2019 Евгений Клебан. All rights reserved.
//

import Foundation

struct Item {
    var id: String
    var imagePath: String
    var moviePath: String
    
    init?(json: [String: String]) {
        
        guard let id = json["id"],
            let imagePath = json["image_path"],
            let moviePath = json["movie_path"]
            else {
                return nil }
        
        
        self.id = id
        self.imagePath = imagePath
        self.moviePath = moviePath
    }
}
