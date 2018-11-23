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
    
    init(view: UIViewController) {
        self.view = view
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
        let controller: UIViewController = ((view.storyboard?.instantiateViewController(withIdentifier: "MemberView"))!)
        return controller
    }
    
    func setUserDefaultsLogin(member_id: Int, member_name: String) {
        UserDefaults.standard.set(true, forKey: "isLogin")
        UserDefaults.standard.set(member_id, forKey: "member_id")
        UserDefaults.standard.set(member_name, forKey: "member_name")
    }
    
    func setUserDefaultsLogout() {
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set(nil, forKey: "member_id")
        UserDefaults.standard.set(nil, forKey: "member_name")
    }
}
