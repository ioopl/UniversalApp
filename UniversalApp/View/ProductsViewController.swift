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

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Initialisation/Setup
    private func setupUI() {

        guard self.hasConnectivity() else {
            self.showAlertView(
                title: NSLocalizedString("TITLE_NETWORK_ERROR", comment: "Title for network error"),
                message: NSLocalizedString("MESSAGE_CONNECTION_OFFLINE", comment: "Message shown when connection is offline."),
                okTitle: NSLocalizedString("BTN_RETRY", comment: "Title for Retry button"),
                okHandler: { (action) -> Void in
                    // Try again method here
            },
                cancelButton: true,
                cancelTitle: NSLocalizedString("BTN_CANCEL", comment: "Default cancel button title"),
                cancelHandler: nil
            )
            return
        }
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
