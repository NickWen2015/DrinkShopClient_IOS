//
//  Member.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/5.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

//MARK: - Structs for Member info.
struct Member: Codable {
    var member_id: Int = 0
    var member_account: String = ""
    var member_password: String = ""
    var member_name: String = ""
    var member_birthday: String = ""
    var member_sex: String = ""
    var member_mobile: String = ""
    var member_email: String = ""
    var member_address: String = ""
    var member_status:String = ""
    
}


extension Communicator {
    
    //會員登入是否成功回傳boolean
    func isUserValid(name: String, password: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "isUserValid", ACCOUNT_KEY: name, PASSWORD_KEY: password]
        doPost(urlString: MEMBERSERVLET_URL, parameters: parameters, completion: completion)
    }
    
    //會員帳密登入成功回傳member物件
    func findMemberByAccountAndPassword(name: String, password: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "findMemberByAccountAndPassword", ACCOUNT_KEY: name, PASSWORD_KEY: password]
        return doPost(urlString: MEMBERSERVLET_URL, parameters: parameters, completion: completion)
        
    }
    
    //會員id查詢會員資料成功回傳member物件
    func getMemberById(member_id: String, completion: @escaping DoneHandler) {
//        let member: Member? = nil
        
        let parameters: [String: Any] = [ACTION_KEY: "findById", MEMBER_ID_KEY: member_id]
        doPost(urlString: MEMBERSERVLET_URL, parameters: parameters, completion: completion)
    }
}
