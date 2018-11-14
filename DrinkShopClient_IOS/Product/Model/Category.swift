//
//  Category.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/9.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "category_id" : id,
            "category_name" : name,
        ]
    }
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case id = "category_id"
        case name = "category_name"
    }
}

