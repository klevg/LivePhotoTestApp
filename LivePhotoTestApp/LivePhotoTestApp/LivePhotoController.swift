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
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.isUserInteractionEnabled = false
        self.createButton.setTitleColor(UIColor.blue.withAlphaComponent(0.5), for: .normal)
        self.viewButton.isUserInteractionEnabled = false
        self.viewButton.setTitleColor(UIColor.blue.withAlphaComponent(0.5), for: .normal)
        self.saveButton.isUserInteractionEnabled = false
        self.saveButton.setTitleColor(UIColor.blue.withAlphaComponent(0.5), for: .normal)
        
        self.downloadPhoto(urlString: imagePathURL) { (filePathPhoto) in
            self.downloadVideo(urlString: self.moviePathURL) { (filePathVideo) in
                self.movieFilePath = filePathVideo
                self.imageFilePath = filePathPhoto
                DispatchQueue.main.sync {
                    self.createButton.isUserInteractionEnabled = true
                    self.createButton.setTitleColor(UIColor.blue.withAlphaComponent(1), for: .normal)
                }
            }
        }
        
    }
    
    @IBAction func createButton(_ sender: UIButton) {
        createLivePhoto(photoPath: imageFilePath, videoPath: movieFilePath)
    }
    @IBAction func viewButton(_ sender: UIButton) {
        viewLivePhoto()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveLivePhoto()
    }
    
    private func createLivePhoto(photoPath: String, videoPath: String) {

        LPLivePhotoGenerator.create(inputImagePath: photoPath, inputVideoPath: videoPath) { (livePhoto: LPLivePhoto?, error: Error?) in
            if let livePhoto = livePhoto {
                self.livePhoto = livePhoto
                self.viewButton.isUserInteractionEnabled = true
                self.viewButton.setTitleColor(UIColor.blue.withAlphaComponent(1), for: .normal)
                print("create live photo")
                self.viewLivePhoto()
            }
            
            if let error = error {
                print(error)
            }
        }
        
    }
    
    private func viewLivePhoto() {
        let livePhotoViewController = LivePhotoViewControllerFromDemo()
        livePhotoViewController.phLivePhoto = livePhoto?.phLivePhoto
        self.present(livePhotoViewController, animated: true) {
            self.saveButton.isUserInteractionEnabled = true
            self.saveButton.setTitleColor(UIColor.blue.withAlphaComponent(1), for: .normal)
        }
    }
    
    private func saveLivePhoto() {
        self.saveButton.isUserInteractionEnabled = false
        
        livePhoto?.writeToPhotoLibrary(completion: { (livePhoto: LPLivePhoto, error: Error?) in
            DispatchQueue.main.sync {
                
                if let error = error {
                    print(error)
                } else {
                    self.saveButton.setTitle("Saved", for: .normal)
                    self.saveButton.setTitleColor(UIColor.green, for: .normal)
                    print("photo saved!")
                }
            }
        })
    }

    private func downloadVideo(urlString: String, completion: @escaping (_ imagePath: String) -> Void) {

        DispatchQueue.global(qos: .default).async(execute: {
            //All stuff here
            print("downloadVideo")
            let url=NSURL(string: urlString)
            let urlData=NSData(contentsOf: url! as URL)
            
            if((urlData) != nil) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let fileName = urlString as NSString;
                let filePath = "\(documentsPath)/\(fileName.lastPathComponent)"
                print(filePath)
                let fileExists = FileManager().fileExists(atPath: filePath)
                if(fileExists) {
                    urlData?.write(toFile: filePath, atomically: true);
                    print("videoSaved")
                    completion(filePath)
                } else {
                    //download
                    DispatchQueue.main.async(execute: { () -> Void in
                        urlData?.write(toFile: filePath, atomically: true)
                        print("videoSaved")
                        completion(filePath)
                    })
                }
            }
        })
    }
    
    private func downloadPhoto(urlString: String, completion: @escaping (_ imagePath: String) -> Void) {
       
        DispatchQueue.global(qos: .default).async(execute: {
            //All stuff here
            print("downloadPhoto")
            let url = NSURL(string: urlString)
            let urlData = NSData(contentsOf: url! as URL)
        
            if((urlData) != nil) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let fileName = urlString as NSString
                fileName.appendingPathComponent("image.jpeg")
                let filePath = "\(documentsPath)/\(fileName.lastPathComponent)"
                print(filePath)
                DispatchQueue.main.async(execute: { () -> Void in
                    urlData?.write(toFile: filePath, atomically: true)
                    print("photoSaved")
                    completion(filePath)
                })
                
            }
        })
        
    }
}


