//
//  ViewController.swift
//  LivePhotoTestApp
//
//  Created by Евгений Клебан on 3/27/19.
//  Copyright © 2019 Евгений Клебан. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private var itemsForNewRequest = [Item]()
    private var items = [Item]()
    private var defaultLink = "https://wallpapers.mediacube.games/api/photos/"
    private var currentLink = ""
    private var curentImagePathForSegue = ""
    private var curentMoviePathForSegue = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRequest(url: defaultLink)
    }
    
    @IBOutlet weak var numberOfPage: UILabel!
    
    @IBAction func nextButton(_ sender: UIButton) {
        if let nextPage = Pagination.nextLink {
            getRequest(url: nextPage)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if let backPage = Pagination.previousLink {
            getRequest(url: backPage)
        }
    }
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        if currentLink != "" {
            getRequest(url: currentLink)
        } else {
            getRequest(url: defaultLink)
        }
    }
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    private var scale: CGFloat = 1
    
    override func  viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let cv = collectionView?.frame {
            flowLayout?.itemSize = CGSize(width: (cv.size.width - 20 ) / 3 * scale, height: (cv.size.width - 20) / 3 * scale)
        }
    }
    
    func presentAlertWithError(error: Error) {
        let alert = UIAlertController(
            title: "Search failed",
            message: "\(error.localizedDescription)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
        ))
        present(alert, animated: true)
    }
    
    func getRequest(url: String) {
        self.currentLink = url
        self.itemsForNewRequest = []
        request(url).validate().responseJSON { (responseJSON) in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print(statusCode)
            
            switch responseJSON.result {
                
            case .success(let value):
                guard let jsonArray = value as? [String: Any] else { return }
                
                
                if let dataArray = jsonArray["data"] as?  Array<[String: String]> {
                    for dataItem in dataArray {
                        guard let item = Item(json: dataItem) else { return }
                        self.itemsForNewRequest.append(item)
                    }
                }
                
                if let links = jsonArray["links"] as? Dictionary<String, Any> {
                    Pagination.firstLink = links["first"] as? String ?? ""
                    Pagination.lastLink = links["last"] as? String ?? ""
                    Pagination.previousLink = links["prev"] as? String ?? ""
                    Pagination.nextLink = links["next"] as? String ?? ""
                }
                if let meta = jsonArray["meta"] as? [String: Any] {
                    Pagination.currentPage = meta["current_page"] as? Int ?? nil
                    Pagination.lastPage = meta["last_page"] as? Int ?? nil
                    
                }
                
                if Pagination.nextLink == "" {
                    self.nextButton.isUserInteractionEnabled = false
                    self.nextButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
                } else {
                    self.nextButton.isUserInteractionEnabled = true
                    self.nextButton.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
                }
                
                if Pagination.previousLink == "" {
                    self.backButton.isEnabled = false
                    self.backButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
                } else {
                    self.backButton.isEnabled = true
                    self.backButton.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
                }
                self.items = self.itemsForNewRequest
                
                DispatchQueue.main.async {
                    self.numberOfPage.text = String(Pagination.currentPage!)
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                self.presentAlertWithError(error: error)
                print(error)
            }
        }
        
    }
    
}


// MARK: Navigation

extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailVCSegue" {
            if let destinationVC = segue.destination as? LivePhotoViewController {
                destinationVC.imagePathURL = curentImagePathForSegue
                destinationVC.moviePathURL = curentMoviePathForSegue
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = items[indexPath.item]
        curentImagePathForSegue = item.imagePath
        curentMoviePathForSegue = item.moviePath
        
        performSegue(withIdentifier: "detailVCSegue", sender: self)
    }
}


// MARK: CollectionViewDataSource

extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "collectionViewCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CollectionViewCell else {
            fatalError("The dequeued cell is not an instance of CollectionViewCell.")
        }
        cell.image = nil
        
        cell.spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: URL(string: (self?.items[indexPath.row].imagePath)!)!)
            DispatchQueue.main.async {
                if let imageData = urlContents {
                    if let image = UIImage(data: imageData) {
                        if cell.image == nil {
                            cell.image = image
                            cell.imageView.contentMode = .scaleAspectFit
                            
                            print("Image is load \(indexPath.row)")
                        }
                    }
                    
                }
            }
            
        }
        return cell
    }
    
}
