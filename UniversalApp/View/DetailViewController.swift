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
            var artistName = String()
            var imageMediumURL = String()
            guard let jsonDict = response as? [String:Any] else { return }
            guard let tracksDictionary = jsonDict["track"] as? [String: Any] else {
                self.showAlert()
                return }
            guard let trackName = tracksDictionary["name"] else { return }
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
    
    // MARK: - Error Handling
    private func showAlert() {
        showAlertView(
            title: nil,
            message: NSLocalizedString("MESSAGE_TRACK_NOT_FOUND", comment: "Message shown when track is not available."),
            okTitle: NSLocalizedString("BTN_OK", comment: "Title for OK button"),
            okHandler: { (action) -> Void in
                self.navigationController?.popViewController(animated: true)
        })
    }
}
