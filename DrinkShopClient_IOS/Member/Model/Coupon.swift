//
//  Voucher.swift
//  DSVoucher
//
//  Created by Lucy on 2018/12/5.
//  Copyright © 2018 Lucy. All rights reserved.
//

import Foundation

struct Coupon: Codable {
    var coupon_id: Int = 0
    var member_id: Int = 0
    var coupon_no: String = ""
    var coupon_discount: Double = 10.0//預設沒打折
    var coupon_status: String = ""
    var coupon_start: String = ""
    var coupon_end: String = ""
}


extension Communicator {
    
    //新增優惠卷
    func couponInsert(coupon: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "insert", COUPON_KEY: coupon]
        doPost(urlString: COUPONSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //修改優惠卷狀態為已使用0 >> 1
    func couponUpdateStatus(coupon: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "updateCouponStatus", COUPON_KEY: coupon]
        doPost(urlString: COUPONSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //coupon_id查詢coupon資料成功回傳coupon物件
    func findCouponById(coupon_id: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "findCouponById", COUPON_ID_KEY: coupon_id]
        doPost(urlString: COUPONSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //member_id查詢coupon資料成功回傳coupon物件陣列
    func getAllCouponsByMemberId(member_id: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "getAllCouponsByMemberId", MEMBER_ID_KEY: member_id]
        doPost(urlString: COUPONSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //useStatus(0: 未使用, 1: 已使用)查詢coupon資料成功回傳coupon物件陣列
    func getAllCoupons(useStatus: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "getAllCoupons", COUPON_STATUS_KEY: useStatus]
        doPost(urlString: COUPONSERVLET_URL, parameters: parameters, completion: completion)
    }

  
}
