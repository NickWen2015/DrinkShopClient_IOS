//
//  Product.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/9.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct Product: Codable {
    let ID: Int
    let categoryId: Int
    let category: String
    let name: String
    let priceM: Int
    let priceL: Int
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "id" : ID,
            "categoryId" : categoryId,
            "Category" : category,
            "Name" : name,
            "MPrice" : priceM,
            "LPrice" : priceL,
        ]
    }
}

extension Product {
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case categoryId = "categoryId"
        case category = "Category"
        case name = "Name"
        case priceM = "MPrice"
        case priceL = "LPrice"
    }
}
