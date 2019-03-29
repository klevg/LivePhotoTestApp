////
////  Request.swift
////  LivePhotoTestApp
////
////  Created by Евгений Клебан on 3/27/19.
////  Copyright © 2019 Евгений Клебан. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//class Request {
//    var items = [Item]()
//    
////    func getRequest() {
////        request("https://wallpapers.mediacube.games/api/photos/").validate().responseJSON { (responseJSON) in
////            guard let statusCode = responseJSON.response?.statusCode else { return }
////            print(statusCode)
////            
////            switch responseJSON.result {
////                
////            case .success(let value):
////                guard let jsonArray = value as? [String: Any] else { return }
////                
////                
////                if let dataArray = jsonArray["data"] as?  Array<[String: String]> {
////                    for dataItem in dataArray {
////                        guard let item = Item(json: dataItem) else { return }
////                        self.items.append(item)
////                    }
////                }
////                
////                if let links = jsonArray["links"] as? Dictionary<String, Any> {
////                    Pagination.firstLink = links["first"] as? String ?? ""
////                    Pagination.lastLink = links["last"] as? String ?? ""
////                    Pagination.previousLink = links["prev"] as? String ?? ""
////                    Pagination.nextLink = links["next"] as? String ?? ""
////                }
////                if let meta = jsonArray["meta"] as? [String: Any] {
////                    Pagination.currentPage = meta["current_page"] as? Int ?? nil
////                    Pagination.lastPage = meta["last_page"] as? Int ?? nil
////                    
////                }
////            case .failure(let error):
////                print(error)
////            }
////        }
////    }
//    
////
////    func fetchImage(item: Item, complition: @escaping (Data?) -> ()) {
////        let link = item.imagePath
//////        var data =  Data()
//////
////        request(link).validate().responseData { (response) in
////            if response.error == nil {
////                print(response.result)
////
////                // Show the downloaded image:
////                if let dataOfImage = response.result.value {
////                    //self.downloadImage.image = UIImage(data: data)
////              //  data = dataOfImage
////                    complition(dataOfImage)
////                } else {
////                    print("error with download imageData")
////                    //return data
////                }
////            }
////            //return complition(nil, response.error)
////
////        }
//
//        //             guard let statusCode = response.response?.statusCode else { return }
////            switch response.result {
////            case .success:
////                guard let data = response.data else { return }
////                self.data = data
////            case .failure(let error):
////                print(error)
////            }
////        }
//    
//}
//    
//    
//
