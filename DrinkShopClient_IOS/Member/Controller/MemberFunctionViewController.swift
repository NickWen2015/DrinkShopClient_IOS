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
        if let isLogin = UserDefaults.standard.object(forKey: "isLogin") as? Bool {
            if(isLogin){
                print("已登入")
            }else{
                print("未登入")
            }
        } else {//isLogin == nil (未登入)
            print("沒有偏好設定")
            Communicator.shared.isUserValid(name: "nick", password: "0000") {result,error in
                
                guard let result = result else {
                   
                    return
                }
                print("result: \(result)")
            }
            
            let alertController = UIAlertController(title: "登入", message:
                "登入成功！", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
          
//            let memberVC = MemberViewController()
//            self.present(memberVC, animated: true, completion: nil)
//            let memberStoryboard = UIStoryboard(name:"MemberView", bundle: nil)
//            let memberVC = memberStoryboard.instantiateViewController(withIdentifier: "MemberViewController") as! ViewController
//            self.present(memberVC, animated: true, completion: nil)
        }
        
    }
    

  
}

extension Communicator {
    func isUserValid(name: String, password: String, completion: @escaping DoneHandler) -> Bool {
        var isUserValid = false
        let parameters: [String: Any] = [ACTION_KEY: "isUserValid", ACCOUNT_KEY: name, PASSWORD_KEY: password]
        doPost(urlString: MEMBERSERVLET_URL, parameters: parameters, completion: completion)
        return isUserValid
    }
}
