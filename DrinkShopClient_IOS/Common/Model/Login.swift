//
//  Login.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/22.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class Login {
    
    let view: UIViewController!
    var from = ""
    
    init(view: UIViewController) {
        self.view = view
    }
    
    init(view: UIViewController, from: String) {
        self.view = view
        self.from = from
    }
    
    func login() {
        //取偏好設定判斷是否已登入
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool {
            if(isLogin){
                PrintHelper.println(tag: "Login", line: #line, "已登入")
            }else{
                PrintHelper.println(tag: "Login", line: #line, "未登入")
                //呼叫登入畫面
                if let controller = loginController() {
                    view.present(controller, animated: true, completion: nil)
                }
            }
        } else {//isLogin == nil (沒有登入狀態)
            print("沒有偏好設定")
            //呼叫登入畫面
            if let controller = loginController() {
                view.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func loginController() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Member", bundle: nil)
        let controller: UIViewController = storyboard.instantiateViewController(withIdentifier: "MemberView")
        let delegate: LoginToMemberViewFetchDataDelegate!
        delegate = controller as! MemberViewController
        delegate.fetchData(from: from)
        return controller
    }
    
    func setUserDefaultsLogin(member_id: Int, member_name: String, member_sex: String) {
        UserDefaults.standard.set(true, forKey: "isLogin")
        UserDefaults.standard.set(member_id, forKey: "member_id")
        UserDefaults.standard.set(member_name, forKey: "member_name")
        UserDefaults.standard.set(member_sex, forKey: "member_sex")
    }
    
    func setUserDefaultsLogout() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set(nil, forKey: "member_id")
        UserDefaults.standard.set(nil, forKey: "member_name")
        UserDefaults.standard.set(nil, forKey: "member_sex")
    }
}
