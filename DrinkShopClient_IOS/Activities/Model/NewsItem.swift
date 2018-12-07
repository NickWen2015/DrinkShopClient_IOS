//
//  NewsItem.swift
//  DrinkShopClient_IOS
//
//  Created by 周芳如 on 2018/11/14.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation

struct NewsItem: Codable {
    
    var id: Int?
    var name: String?
    var sDate: String?
    var eDate: String?
    var desc: String?
    var sort: Int?
    var status: String?
    enum CodingKeys: String, CodingKey {
        case id = "activity_id"
        case name = "activity_name"
        case sDate = "activity_date_start"
        case eDate = "activity_date_end"
        case desc = "activity_desc"
        case sort = "activity_sort"
        case status = "activity_status"
        
    }
}

extension Communicator {
    
    func retriveIds(completion: @escaping DoneHandler) {
        let parameters:[String : Any]  = [ACTION_KEY: "getNews_activity_id"]
        
        return doPost(urlString: NEWSSERVLET_URL, parameters: parameters, completion: completion)
    }
}
