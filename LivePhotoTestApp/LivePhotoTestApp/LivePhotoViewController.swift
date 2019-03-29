//
//  LivePhotoViewController.swift
//  LivePhotoTestApp
//
//  Created by Евгений Клебан on 3/29/19.
//  Copyright © 2019 Евгений Клебан. All rights reserved.
//

import UIKit
import LPLivePhotoGenerator

class LivePhotoViewController: UIViewController {
    
    var moviePathURL = ""
    var imagePathURL = ""
    
    private var movieFilePath = ""
    private var imageFilePath = ""
    
    private var livePhoto: LPLivePhoto?
    private var createActivityIndicatorView: UIActivityIndicatorView!
//    private var livePhotoPreviewView: PHLivePhotoView!
//    private var phLivePhoto: PHLivePhoto! = PHLivePhoto()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        createActivityIndicatorView.center = view.center
//        livePhotoPreviewView = PHLivePhotoView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//        livePhotoPreviewView.backgroundColor = .yellow
//        livePhotoPreviewView.livePhoto = phLivePhoto
//        view.addSubview(livePhotoPreviewView)
        view.addSubview(createActivityIndicatorView)

        self.downloadImage(imageURL: imagePathURL) { (imageFilePath) in
            self.downloadMovie(movieURL: self.moviePathURL, completion: { (movieFilePath) in
                self.createLivePhoto(photoPath: imageFilePath, videoPath: movieFilePath)
            })
        }
    }
    
    func createLivePhoto(photoPath: String, videoPath: String) {
//
//        createActivityIndicatorView.startAnimating()
//        LPLivePhotoGenerator.create(inputImagePath: photoPath, inputVideoPath: videoPath) { (livePhoto: LPLivePhoto?, error: Error?) in
//            if let livePhoto = livePhoto {
//                self.livePhoto = livePhoto
//                self.phLivePhoto = livePhoto.phLivePhoto
//                self.createActivityIndicatorView.stopAnimating()
//            }
//            print("live photo is created")
//            if let error = error {
//                print(error)
//            }
//        }
//        livePhotoPreviewView.setNeedsDisplay()
//        livePhotoPreviewView.startPlayback(with: .full)
//
        createActivityIndicatorView.startAnimating()
        LPLivePhotoGenerator.create(inputImagePath: photoPath, inputVideoPath: videoPath) { (livePhoto: LPLivePhoto?, error: Error?) in
            
            if let error = error {
                print(error)
            } else if let livePhoto = livePhoto {
                self.livePhoto = livePhoto
                self.createActivityIndicatorView.stopAnimating()
                print("create live photo")
            }
        }
        // used the implementation of the developer's library, to find out where the error is. I could not find a mistake :(
        let livePhotoViewController = LivePhotoViewControllerFromDemo()
        livePhotoViewController.phLivePhoto = livePhoto?.phLivePhoto
        self.present(livePhotoViewController, animated: true)
    }
    
    private func downloadMovie(movieURL: String, completion: @escaping (_ imagePath: String) -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            print("downloadVideo")
            let url = NSURL(string: movieURL)
            let urlData = NSData(contentsOf: url! as URL)
            
            if let data = urlData {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let fileName = movieURL as NSString
                let filePath = "\(documentsPath!)/\(fileName.lastPathComponent)"
                print(filePath)
                    DispatchQueue.main.async(execute: { () -> Void in
                        data.write(toFile: filePath, atomically: true)
                        print("videoSaved")
                        completion(filePath)
                    })
             }
        })
    }
    
    private func downloadImage(imageURL: String, completion: @escaping (_ imagePath: String) -> Void) {
        DispatchQueue.global(qos: .default).async(execute: {
            print("downloadPhoto")
            if let url = NSURL(string: imageURL) {
                let urlData = NSData(contentsOf: url as URL)
                
                if let data = urlData {
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    let fileName = imageURL as NSString
                    fileName.appendingPathComponent("image.jpeg")
                    let filePath = "\(documentsPath!)/\(fileName.lastPathComponent)"
                    print(filePath)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        data.write(toFile: filePath, atomically: true)
                        print("photoSaved")
                        completion(filePath)
                    })
                }
            }
        })
    }
}
