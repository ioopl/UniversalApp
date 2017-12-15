//
//  DetailViewController.swift
//  UniversalApp
//
//  Created by UHS on 15/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit

// Global Variable
public var objectId = String()
class DetailViewController: UIViewController {
    
    // MARK: - Variables
    var results = [Results]()
    var image = UIImage()
    
    // MARK: - Outlets
    @IBOutlet var background: UIImageView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = image
        mainImageView.image = image
        fetchDatafromURL(mbid: objectId)
    }
    
    // MARK: - API Call
    private func fetchDatafromURL(mbid: String) {
        results.removeAll()
        let url = "\(Constant.APIURLGETINFO)&api_key=\(Constant.APIKey)&format=json&mbid=\(mbid)"
        API.fetchDatafromURLInBackground(url: url) { (response, error) in
            
            if let jsonDict = response as? [String:Any],
                let tracksDictionary = jsonDict["track"] as? [String: Any] {
                guard let trackName = tracksDictionary["name"] else { return }
                var artistName = String()
                var imageMediumURL = String()
                for trackValue in tracksDictionary {
                    if trackValue.key == "album" {
                        guard let albumDict = tracksDictionary["album"] as! [String:Any]? else { return }
                        guard let artName = albumDict["artist"] else { return }
                        artistName = artName as! String
                        let imagesArray = albumDict["image"] as! NSArray
                        // Get the large image value from index 2
                        let imageMediumArray = imagesArray[2]
                        guard let imageDictionary = imageMediumArray as? [String : AnyObject] else { return }
                        let imgMedium = imageDictionary["#text"] as! String
                        imageMediumURL = imgMedium
                    }
                }
                // Back to the main queue(thread), to access any UIKit classes.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.labelTitle.text = trackName as? String
                    self.labelDetail.text = artistName
                    let imageURL = imageMediumURL
                    self.mainImageView.downloadedFrom(link: imageURL, contentMode: UIViewContentMode.scaleAspectFill)
                })
            }
        }
    }
}
