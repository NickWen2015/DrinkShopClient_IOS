//
//  MemberFunctionViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/10.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class MemberFunctionViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取偏好設定判斷是否已登入
        if let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool {
            if(isLogin){
//                printHelper.println(tag: TAG, line: #line, "已登入")
                print("已登入")
            }else{
                print("未登入")
                //呼叫登入畫面
                if let controller = loginController() {
                    present(controller, animated: true, completion: nil)
                }
            }
        } else {//isLogin == nil (沒有登入狀態)
            print("沒有偏好設定")
            //呼叫登入畫面
            if let controller = loginController() {
                present(controller, animated: true, completion: nil)
            }
            
            
        
        }
        
    }
    
    //按下登出按鈕
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        
        //清除偏好設定的登入狀態
        UserDefaults.standard.set(false, forKey: "isLogin")
        
        //呼叫登入頁
        if let controller = loginController() {
            present(controller, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func unwindToMemberFunctionViewController(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    func loginController() -> UIViewController? {
        let controller: UIViewController = ((storyboard?.instantiateViewController(withIdentifier: "MemberView"))!)
        return controller
    }
}


