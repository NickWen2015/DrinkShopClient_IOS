//
//  Communicator.swift
//  HelloMyPushMessage
//
//  Created by Nick Wen on 2018/10/24.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation
import Alamofire


//共用參數
let ACTION_KEY = "action"
let ID_KEY = "id"
let IMAGESIZE_KEY = "imageSize"

//會員用到的參數
let ACCOUNT_KEY = "name"
let PASSWORD_KEY = "password"
let MEMBER_ID_KEY = "member_id"
let MEMBER_KEY = "member"
let COUPON_KEY = "coupon"
let COUPON_STATUS_KEY = "status"
let COUPON_ID_KEY = "coupon_id"
let ORDER_KEY = "order"
let ORDER_ID_KEY = "order_id"



//result:[String:Any] is dictionary declaration.
typealias DoneHandler = (_ result: Any?, _ error:Error?) -> Void
typealias DownloadDoneHandler = (_ result:Data?, _ error:Error?) -> Void


class Communicator {  //Singleton instance 單一實例模式

    // SERVER_URL 常數
    static let BASEURL = Common.SERVER_URL
    let MEMBERSERVLET_URL = BASEURL + "MemberServlet"
    let NEWSSERVLET_URL = BASEURL + "NewsServlet"
    let ORDERSSERVLET_URL = BASEURL + "OrdersServlet"
    let PRODUCTSERVLET_URL = BASEURL + "ProductServlet"
    let COUPONSERVLET_URL = BASEURL + "CouponServlet"
    let ORDERSERVLET_URL = BASEURL + "OrdersServlet"
    
    static let shared = Communicator()
    private init() {
        
    }
    
    //MARK: - Common methods.
    func getPhotoById(photoURL: String, id: Int, imageSize: Int = 1080, completion: @escaping DownloadDoneHandler) {
        let parameters:[String : Any] = [ACTION_KEY: "getImage", ID_KEY: id, IMAGESIZE_KEY: imageSize]
        
        return doPostForPhoto(urlString: photoURL, parameters: parameters, completion: completion)
        
    }
    
    // 發Request到Server(圖片)
    private func doPostForPhoto(urlString:String, parameters:[String: Any], completion: @escaping DownloadDoneHandler) {
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            self.handlePhoto(response: response, completion: completion)
            
        }
    }
    
    // 處理Server回傳的圖片
    private func handlePhoto(response: DataResponse<Data>, completion: DownloadDoneHandler) {
        guard let data = response.data else {
            print("data is nil")
            let error = NSError(domain: "Invalid Image object.", code: -1, userInfo: nil)
            completion(nil, error)
            return
        }
        completion(data, nil)
    }
    
    // 發Request到Server(文字)
    func doPost(urlString:String, parameters:[String: Any], completion: @escaping DoneHandler) {
        
        Alamofire.request(urlString, method: HTTPMethod.post , parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleJSONArray(response: response, completion: completion)
        }
    }
    

    // 處理Server回傳的JSON
    private func handleJSONArray(response: DataResponse<Any>, completion: DoneHandler) {
        switch response.result {
        case .success(let json)://enum 夾帶參數
            print("Get success response: \(json)")

            completion(json, nil)

        case .failure(let error):
            print("Get success error: \(error)")
            completion(nil, error)
        }
    }
    
}
