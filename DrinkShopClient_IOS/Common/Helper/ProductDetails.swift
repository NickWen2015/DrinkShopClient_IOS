//
//  ProductDetails.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/3.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

final class ProductDetails {
    static func valueOfTemperature(temperature: Int) -> String {
        var value: String = ""
        switch temperature {
        case 1:
            value = "正常冰"
            break
        case 2:
            value = "少冰"
            break
        case 3:
            value = "微冰"
            break
        case 4:
            value = "去冰"
        case 5:
            value = "正常熱"
            break
        case 6:
            value = "熱一點"
            break
        default:
            break
        }
        return value
    }
    
    static func valueOfSugar(suger: Int) -> String {
        var value: String = ""
        switch suger {
        case 1:
            value = "正常糖"
            break
        case 2:
            value = "少糖"
            break
        case 3:
            value = "半糖"
            break
        case 4:
            value = "微糖"
            break
        case 5:
            value = "無糖"
            break
        default:
            break
        }
        return value
    }
    
    static func valueOfSize(size: Int) -> String {
        var value: String = ""
        switch size {
        case 1:
            value = "中杯"
            break
        case 2:
            value = "大杯"
            break
        default:
            break
        }
        return value
    }
    
}
