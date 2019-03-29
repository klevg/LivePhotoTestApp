//
//  CollectionViewCell.swift
//  LivePhotoTestApp
//
//  Created by Евгений Клебан on 3/27/19.
//  Copyright © 2019 Евгений Клебан. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            spinner.stopAnimating()
            print("set image")
        }
    }
}
