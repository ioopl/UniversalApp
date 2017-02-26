//
//  Product.swift
//  UniversalApp
//
//  Created by UHS on 26/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import Foundation

struct Product {
    
    // MARK: - Variables
    var productId = ""
    var price = ""
    var title = ""
    var image = ""

    init(dictionary : [[String:Any]]) {

        for product in dictionary {
            
            productId = product["productId"] as! String
            title = product["title"] as! String
            image = product["image"] as! String
        }

//        let priceWas = dictionary["was"] as! String
//        let priceNow = dictionary["now"] as! String
    }
}
