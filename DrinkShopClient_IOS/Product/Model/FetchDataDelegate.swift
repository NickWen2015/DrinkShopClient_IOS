//
//  FetchDataDelegate.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/29.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

protocol AddingProductToShoppingCartFetchDataDelegate {
    func fetchData(size: Int, sugar: Int, temperature: Int)
}

protocol AddingProductToShoppingCartTableFetchDataDelegate {
    func fetchData(size: Int, sugar: Int, temperature: Int)
}

protocol LoginToMemberViewFetchDataDelegate {
    func fetchData(from: String)
}

protocol ProductCouponToShoppingCart {
    func fetchData(coupon: Coupon)
}
