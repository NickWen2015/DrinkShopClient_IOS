//
//  ShoppingCart.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/26.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct ShoppingCart {
    var id: Int?
    var productId: Int?
    var category: String?
    var productName: String?
    var size: Int?
    var sizePrice: Int?
    var quantity: Int?
    var sugar: Int?
    var temperature: Int?
    
    
    init() { }
    
    init(id: Int? = 0, productId: Int?, category: String?, productName: String?, size: Int?, sizePrice: Int?, quantity: Int?, sugar: Int?, temperature: Int?) {
        self.id = id
        self.productId = productId
        self.category = category
        self.productName = productName
        self.size = size
        self.sizePrice = sizePrice
        self.quantity = quantity
        self.sugar = sugar
        self.temperature = temperature
    }
    
    
    
}

extension ShoppingCart {
    func getId() -> Int {
        guard let id = id else {
            return 0
        }
        return id
    }
    
    func getProductId() -> Int {
        guard let productId = productId else {
            return 0
        }
        return productId
    }
    
    func getCategory() -> String {
        guard let category = category else {
            return ""
        }
        return category
    }
    
    func getProductName() -> String {
        guard let productName = productName else {
            return ""
        }
        return productName
    }
    
    func getSize() -> Int {
        guard let size = size else {
            return 0
        }
        return size
    }
    
    func getSizePrice() -> Int {
        guard let sizePrice = sizePrice else {
            return 0
        }
        return sizePrice
    }
    
    func getQuantity() -> Int {
        guard let quantity = quantity else {
            return 0
        }
        return quantity
    }
    
    func getSugar() -> Int {
        guard let suger = sugar else {
            return 0
        }
        return suger
    }
    
    func getTemperature() -> Int {
        guard let temperature = temperature else {
            return 0
        }
        return temperature
    }
    
}
