//
//  Member.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/5.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct Member: Codable {
    let member_id: Int
    let member_account: String
    var member_password: String
    var member_name: String
    var member_birthday: String?
    var member_sex: String?
    var member_mobile: String?
    var member_email: String?
    var member_address: String?
    var member_status:String
}


