//
//  MainViewController.swift
//  UniversalApp
//
//  Created by UHS on 14/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

import UIKit
import Reachability
import DLRadioButton
import FoursquareAPIClient
import CoreLocation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // MARK: - Variables
    var results = [Results]()
    var venues: [Venue] = []
    
    // MARK: - Constants
    private let reuseIdentifier = "Cell"
    private var searchTerm = String()
    private let pageSize = "20"

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var radioButtonLocation: DLRadioButton!
    @IBOutlet weak var radioButtonMusic: DLRadioButton!

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
        // Register collection view custom cell class
        collectionView.register(MainCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
        
        guard hasConnectivity() else {
            showAlertView(
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
    
    // MARK: - RadioButton Methods
    @IBAction func radioButtonLocationTapped(_ sender: Any) {
        radioButtonLocation.isSelected = true
        radioButtonMusic.isSelected = false
        searchBar.placeholder = NSLocalizedString("TITLE_SEARCH_LOCATION", comment: "Title for network error")
    }
    
    @IBAction func radioButtonMusicTapped(_ sender: Any) {
        radioButtonMusic.isSelected = true
        radioButtonLocation.isSelected = false
        searchBar.placeholder = NSLocalizedString("TITLE_SEARCH_MUSIC", comment: "Title for network error")
    }
    
    // MARK: - API Call
    private func fetchDatafromURL(url: String) {
        results.removeAll()
        API.fetchDatafromURLInBackground(url: url) { (response, error) in
            
            if let jsonDict = response as? [String:Any],
                let resultsDictionary = jsonDict["results"] as? [String:Any],
                let trackmatchesDictionary = resultsDictionary["trackmatches"] as? [String: Any],
                let trackArray = trackmatchesDictionary["track"] as? [[String: Any]] {
                for trackValue in trackArray {
                    let response = Results(dictionary: [trackValue])
                    self.results.append(response)
                }
                // Back to the main queue(thread), to access any UIKit classes.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    // Foursquare API Call
    private func getFoursquareVenueSearchfromCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        venues.removeAll()
        let client = FoursquareAPIClient(clientId: "CXCD5Q3O5P3RSARBDAECCIUQN45ZVO1PEKEEH5IRWQXDJDTQ", clientSecret: "QPOOVZEKEVBE5UC05VSM2BPK4Z3C5IPNFWAQKP2G21MU1MPG")
        
        let parameter: [String: String] = [
            "ll": "\(lat),\(lon)",
            "limit": "10",
            ];
        
        client.request(path: Constant.APIURLLOCATION, parameter: parameter) { result in
            switch result {
            case let .success(data):
                self.bindDataToView(data: data)
                
            case let .failure(error):
                // Error handling
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .responseParseError(responseParseError):
                    print(responseParseError)   // e.g. JSON text did not start with array or object and option to allow fragments not set.
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }
        }
    }
    
    // Get Coordinates from Apple Core Location API
    private func fetchCoordinatesfromLocation(location: String) {
        API.getCoordinate(addressString: location) { (cllocation, error) in
            let lat = cllocation.latitude
            let lon = cllocation.longitude
            self.getFoursquareVenueSearchfromCoordinates(lat: lat, lon: lon)
        }
    }
    
    func bindDataToView(data: Data) {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let response = try decoder.decode(Response<SearchResponse>.self, from: data)
            self.venues = response.response.venues
            // Back to the main queue(thread), to access any UIKit classes.
            DispatchQueue.main.async(execute: { () -> Void in
                self.collectionView.reloadData()
            })
            
        } catch let error as NSError    {
            print(error)
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
        if radioButtonLocation.isSelected == true {
            return venues.count
        } else {
        return results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if radioButtonLocation.isSelected {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
            let venue = self.venues[(indexPath as NSIndexPath).row]
            // Configure the cell...
            cell.labelTitle?.text = venue.name
            cell.labelPrice?.text = venue.location.address
            
            var categoryIconURL: String? = nil
            if let categories = venue.categories {
                if !categories.isEmpty {
                    categoryIconURL = categories[0].icon.categoryIconUrl
                }
            }
            if let imageURL = categoryIconURL  {
                cell.backgroundColor = UIColor.gray
                cell.imageViewThumbnail.downloadedFrom(link: imageURL, contentMode: UIViewContentMode.scaleAspectFill)
            } else {
                cell.imageViewThumbnail.image = UIImage()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
            // add a border
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.3
            
            // ensure array is not empty
            let count = results.count
            if count > 0 {
                cell.labelTitle.text = results[indexPath.row].name
                cell.labelPrice.text = results[indexPath.row].artist
                cell.labelID.text = results[indexPath.row].mbid
                let imageURL = results[indexPath.row].image
                cell.imageViewThumbnail.downloadedFrom(link: imageURL, contentMode: UIViewContentMode.scaleAspectFill)
            }
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    // MARK: - Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell else { return }
        guard let mbid = cell.labelID.text else { return }
        objectId = mbid
        performSegue(withIdentifier: Constant.segueIdentifierMainController, sender: self)
    }
    
    // MARK: - UISearchBarDelegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keywords = searchBar.text else { return }
        let finalKeywords = keywords.replacingOccurrences(of: " ", with: "+")
        searchTerm = finalKeywords
        
        // Display searched term in title
        title = "\(keywords.capitalized)"
        if radioButtonLocation.isSelected == true {
            fetchCoordinatesfromLocation(location: searchTerm)
        } else {
            let url = "\(Constant.APIURLMUSIC)&track=\(searchTerm)&api_key=\(Constant.APIKey)&format=json"
            fetchDatafromURL(url: url)
        }
        // Hide keyboard
        view.endEditing(true)
    }
}
