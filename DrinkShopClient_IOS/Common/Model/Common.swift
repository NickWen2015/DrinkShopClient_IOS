//
//  Common.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/5.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct Common {
    //連線SERVER_URL(網址ip須根據當下網路偏好設定內網路位址自行更改)
   static let SERVER_URL = "http://192.168.1.85:8080/DrinkShop_Web/"
   
    // 依傳入的日期格式、日期轉換成日期
    // - Parameters:
    //   - strFormat: 日期格式,ex:"yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd"
    //   - strDate: 日期
    // - Returns: Date
    // - Example: Common.getDateFromString(strFormat: "yyyy-MM-dd", strDate: "2018-11-23")  >> 2018-11-23 00:00:00 +0000
    static func getDateFromString(strFormat: String, strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "zh_TW")
        return dateFormatter.date(from: strDate)!
    }
    
    // 依傳入的日期格式、日期轉換成字串
    // - Parameters:
    //   - strFormat: 日期格式
    //   - date: 日期(Date)
    // - Returns: String
    static func getStringFromDate(strFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "zh_TW")
        return dateFormatter.string(from: date)
    }
}
