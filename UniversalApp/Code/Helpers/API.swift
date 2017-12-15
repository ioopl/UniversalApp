//
//  API.swift
//  UniversalApp
//
//  Created by UHS on 15/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit
import Alamofire

class API: NSObject {

    // MARK: - API (Get Method)
    /**
     Passes the URL to the server for data.
     - parameter url: url for the API
     - returns:  JSON Object of type Any.
     */
    class internal func fetchDatafromURLInBackground(url: String, completion: @escaping (_ JSONObject: Any?, _ error: NSError?) ->()) {

        Alamofire.request(url, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in

            switch(response.result) {
            case .success :
                if let data = response.result.value {
                    completion(data, nil)
                }
                break

            case .failure(let error) :
                completion(nil, error as NSError?)
                break
            }
        }
    }
}
