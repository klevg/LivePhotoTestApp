//
//  LivePhotoViewController.swift
//  LivePhotoTestApp
//
//  Created by Евгений Клебан on 3/29/19.
//  Copyright © 2019 Евгений Клебан. All rights reserved.
//

import UIKit
import Alamofire
import PhotosUI

class LivePhotoViewController: UIViewController {
    
    private var imagePathString = String()
    private var videoPathString = String()
    private var videoFilePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func downloadVideo()
    {
        let urlString = "https://wallpapers.mediacube.games/files/live_photo/c43bf2bf-0be6-4644-a963-6b2513cb803f/movie/MOVE.MOV"
        
        DispatchQueue.global(qos: .default).async(execute: {
            //All stuff here
            
            print("downloadVideo");
            let url=NSURL(string: urlString);
            let urlData=NSData(contentsOf: url! as URL);
            
            if((urlData) != nil)
            {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                
                let fileName = urlString as NSString;
                
                let filePath="\(documentsPath)/\(fileName.lastPathComponent)";
                print(filePath)
                let fileExists = FileManager().fileExists(atPath: filePath)
                
                if(fileExists){
                    print("\(filePath) asdasdasdiasjdbk")
                    urlData?.write(toFile: filePath, atomically: true);
                    print("videoSaved");
                    self.videoPathString = filePath
                    // File is already downloaded
                }
                else{
                    
                    //download
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        print("\(filePath) asdasdasdiasjdbk")
                        urlData?.write(toFile: filePath, atomically: true);
                        print("videoSaved");
                    })
                }
            }
        })
    }
        
}
