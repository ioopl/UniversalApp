//
//  Constant.swift
//  UniversalApp
//
//  Created by UHS on 14/12/2017.
//  Copyright © 2017 Apkia Technologies. All rights reserved.
//

struct Constant {
    static var APIKey: String = "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
    static var PageSize: String = "20"
    static var SearchedTerm = ""
    static var APIURL: String = "https://api.johnlewis.com/v1/products/search?q=\(SearchedTerm)&key=\(APIKey)&pageSize=\(PageSize)"
}
