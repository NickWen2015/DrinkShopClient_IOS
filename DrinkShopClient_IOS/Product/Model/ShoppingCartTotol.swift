//
//  ShoppingCartTotol.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/26.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct ShoppingCartTotol {
    var price: Int = 0
    var quantity: Int = 0
}

extension ShoppingCartTotol {
    func getPrice() -> Int {
        return price
    }
    
    func getQuantity() -> Int {
        return quantity
    }
}
