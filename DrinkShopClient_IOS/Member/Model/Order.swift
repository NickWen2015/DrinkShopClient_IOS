//
//  Order.swift
//  DSS
//
//  Created by Lucy on 2018/12/4.
//  Copyright © 2018 Lucy. All rights reserved.
//

import Foundation

struct Order: Codable {
    var order_id: Int = 0//訂單id
    var member_id: Int = 0//會員id
    var invoice: String = ""//發票完整號碼
    var invoice_prefix: String = ""//發票前綴
    var invoice_no: String = ""//發票數字
    var order_accept_time: String = ""//訂單接收時間
    var order_finish_time: String = ""//訂單完成時間(表示已經結單)
    var order_type: String = ""//0自取,1外送
    var order_status: String = ""//0未付款,1已付款
    var store_id: Int = 0//商店id
    var delivery_id: Int = 0//外送員id
    var coupon_id: Int = 0//使用優惠卷id
    var store_name: String = ""//店名
    var store_telephone: String = ""//店電話
    var store_mobile: String = ""//店手機
    var store_address: String = ""//店地址
    var store_location_x: String = ""//緯精度x
    var store_location_y: String = ""//緯精度y
    var coupon_discount: Double = 10.0//預設沒打折
    var orderDetailList: [OrderDetail] = []//訂單內容
}

struct OrderDetail: Codable {
    var order_detail_id: Int = 0//訂單明細id
    var order_id: Int = 0
    var product_id: Int = 0
    var size_id: Int = 0
    var sugar_id: Int = 0
    var ice_id: Int = 0
    var product_quantity: Int = 0//產品數量
    var product_name: String = ""//產品名
    var ice_name: String = ""//冰塊
    var sugar_name: String = ""//甜度
    var size_name: String = ""//杯量
    var product_price: Double = 10.0//產品單價
}


extension Communicator {
    
    //member_id查詢order歷史資料成功回傳order物件陣列
    func findOrderHistoryByMemberId(member_id: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "findOrderHistoryByMemberId", MEMBER_ID_KEY: member_id]
        doPost(urlString: ORDERSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //member_id查詢order歷史資料成功回傳order物件陣列
    func findOrderByMemberId(member_id: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "findOrderByMemberId", MEMBER_ID_KEY: member_id]
        doPost(urlString: ORDERSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    
}
