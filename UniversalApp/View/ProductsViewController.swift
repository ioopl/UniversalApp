//
//  ProductsViewController.swift
//  UniversalApp
//
//  Created by UHS on 25/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit
import Reachability

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Variables
    var productObject: Product? = nil
    private let reuseIdentifier = "Cell"

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the CollectionView as views own delegate and datasource
        collectionView.delegate = self
        collectionView.dataSource = self

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

        // Register collection view custom cell class
        collectionView.register(ProductsCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)

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

        fetchDatafromURL()
    }

    private func fetchDatafromURL() {
        let url = "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=3"
        API.fetchDatafromURLInBackground(url: url) { (response, error) in

            //debugPrint(response)
            if let jsonDict = response as? [String:Any],
                let productsArray = jsonDict["products"] as? [[String:Any]] {
                print(productsArray)

                self.productObject = Product(dictionary: productsArray)
                self.collectionView.reloadData()

                //                for product in productsArray {
                //
                //                    guard let productId = product["productId"] as? String else { return }
                //                    productObject.productId = productId
                //                }
                //                let productIdArray = productsArray.flatMap { $0["productId"] as? String }
                //                print(productIdArray)
                //
                //                print(productObject)
                //                for product:AnyObject in productObject {
                //                print(productObject.productId)
                //                }
            }
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

    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductsCollectionViewCell
        cell.labelTitle.text = "Test"
        return cell
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
