//
//  Product.swift
//  UniversalApp
//
//  Created by UHS on 26/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import Foundation

struct Results {
    // MARK: - Variables
    var image = String()
    var mbid = String()
    var name = String()
    var artist = String()
    var url = String()
    
    init(dictionary : [[String:Any]]) {
        for result in dictionary {
            mbid = result["mbid"] as! String
            name = result["name"] as! String
            artist = result["artist"] as! String
            url = result["url"] as! String
            let imagesArray = result["image"] as! NSArray
            // Get the value from index 1
            let imageMediumArray = imagesArray[1]
            guard let imageDictionary = imageMediumArray as? [String : AnyObject] else { return }
            let imageMedium = imageDictionary["#text"] as! String
            image = imageMedium
        }
    }
}
