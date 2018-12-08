//
//  MemberFunctionViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/10.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class MemberFunctionViewController: UIViewController {
    
    @IBOutlet weak var logoutBarBtn: UIBarButtonItem!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var member: Member?
    
    var login: Login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login = Login(view: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        login = Login(view: self)
        
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool, let member_name = UserDefaults.standard.value(forKey: "member_name") as? String, let member_sex = UserDefaults.standard.value(forKey: "member_sex") as? String {
            if(isLogin) {
                logoutBarBtn.title = "登出"
                nameLabel.text = member_name
                if member_sex == "1" {
                    memberImageView.image = UIImage(named: "boy")
                } else {
                    memberImageView.image = UIImage(named: "girl")
                }
                
            } else {
                login.login()
                logoutBarBtn.title = "登入"
            }
        } else {
            login.login()
            logoutBarBtn.title = "登入"
        }
    }
    
    //按下登出按鈕
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
       print("已登出")
       //清除偏好設定的登入狀態
       login.setUserDefaultsLogout()
       nameLabel.text = "未登入"
       logoutBarBtn.title = "登入"
        
        //呼叫登入頁
        login.login()
    }
    
    @IBAction func unwindToMemberFunctionViewController(_ unwindSegue: UIStoryboardSegue) {
        
        PrintHelper.println(tag: "MemberFunctionViewController", line: #line, "unwindToMemberFunctionViewController.")
        
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool,  let member_name = UserDefaults.standard.value(forKey: "member_name") as? String {
        if(isLogin) {
            logoutBarBtn.title = "登出"
            nameLabel.text = member_name
        }else {
            login.login()
            logoutBarBtn.title = "登入"
        }
      
       }
    }


    
}


