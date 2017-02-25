//
//  ProductsViewController.swift
//  UniversalApp
//
//  Created by UHS on 25/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit
import Reachability

class ProductsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Reachability - Check Network Connectivity
    /**
     This API call checks if the Network is available.
     - returns Bool : true if the network is available
     */
    private func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
