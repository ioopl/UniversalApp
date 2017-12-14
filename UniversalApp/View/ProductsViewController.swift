//
//  ProductsViewController.swift
//  UniversalApp
//
//  Created by UHS on 25/02/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit
import Reachability

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // MARK: - Variables
    var products = [Product]()

    // MARK: - Constants
    private let reuseIdentifier = "Cell"
    private var searchTerm = String()
    private let pageSize = "20"

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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

    // MARK: - Initialisation/Setup
    private func setupUI() {

        title = "\(searchTerm.capitalized)(\(pageSize))"

        // Register collection view custom cell class
        collectionView.register(ProductsCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)

        guard self.hasConnectivity() else {
            self.showAlertView(
                title: NSLocalizedString("TITLE_NETWORK_ERROR", comment: "Title for network error"),
                message: NSLocalizedString("MESSAGE_CONNECTION_OFFLINE", comment: "Message shown when connection is offline."),
                okTitle: NSLocalizedString("BTN_RETRY", comment: "Title for Retry button"),
                okHandler: { (action) -> Void in
                    // Try again
                    self.setupUI()
            },
                cancelButton: true,
                cancelTitle: NSLocalizedString("BTN_CANCEL", comment: "Default cancel button title"),
                cancelHandler: nil
            )
            return
        }
    }

    private func fetchDatafromURL() {
        let url = "https://api.johnlewis.com/v1/products/search?q=\(searchTerm)&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=\(pageSize)"
        API.fetchDatafromURLInBackground(url: url) { (response, error) in

            if let jsonDict = response as? [String:Any],
                let productsArray = jsonDict["products"] as? [[String:Any]] {

                for product in productsArray {
                    let prod = Product(dictionary: [product])
                    self.products.append(prod)
                }
                /* OR
                 let prod = Product(dictionary: productsArray)
                 self.products.append(prod)
                 */

                // Back to the main queue(thread), to access any UIKit classes.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView.reloadData()
                })
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

    // MARK: - CollectionView Delegate/Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductsCollectionViewCell
        // add a border
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3

        // ensure arrray is not empty
        let count = products.count
        if count > 0 {
            cell.labelTitle.text = products[indexPath.row].title
            cell.labelPrice.text = "£" + products[indexPath.row].price
            let imageURL = "https:" + products[indexPath.row].image
            cell.imageViewThumbnail.downloadedFrom(link: imageURL, contentMode: UIViewContentMode.scaleAspectFill)
        }
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    // MARK: - UISearchBarDelegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keywords = searchBar.text else { return }
        let finalKeywords = keywords.replacingOccurrences(of: " ", with: "+")
        searchTerm = finalKeywords
        fetchDatafromURL()

        // Hide keyboard
        view.endEditing(true)
    }
}
