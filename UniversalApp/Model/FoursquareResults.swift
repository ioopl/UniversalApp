//
//  FoursquareResults.swift
//  UniversalApp
//
//  Created by UHS on 18/02/2018.
//  Copyright © 2018 Apkia Technologies. All rights reserved.
//

import Foundation

struct Venue: Codable {
    let venueId: String
    let name: String
    let location: Location
    let categories: [VenueCategory]?
    
    private enum CodingKeys: String, CodingKey {
        case venueId = "id"
        case name
        case location
        case categories
    }
}

struct Location: Codable {
    let address: String?
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case address
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct VenueCategory: Codable {
    let categoryId: String
    let name: String
    let icon: VenueCategoryIcon
    
    private enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case name
        case icon
    }
}

struct VenueCategoryIcon: Codable {
    let prefix: String
    let suffix: String
    
    var categoryIconUrl: String {
        return String(format: "%@%d%@", prefix, 88, suffix)
    }
}

struct Response <Response: Codable> : Codable {
    let response: Response
}

struct SearchResponse : Codable {
    let venues: [Venue]
}

