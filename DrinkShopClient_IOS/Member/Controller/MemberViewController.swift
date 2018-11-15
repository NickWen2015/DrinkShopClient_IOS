//
//  MemberViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/7.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //會員登入
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let account: String = accountTextField.text!
        let password: String = passwordTextField.text!
        guard account.count != 0 && password.count != 0 else {
            let alertController = UIAlertController(title: "帳號資料空白", message:
                "帳號或密碼不可留空", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Communicator.shared.isUserValid(name: account, password: password) {result, error in
            
            guard let result = result, let loginStatus = result.first?.value as? Int else {
                assertionFailure("login fail.")
                return
            }
            
            
            if loginStatus == 1 {//["result": 1]
                //跳出登入成功視窗
                let alertController = UIAlertController(title: "登入", message:
                    "登入成功！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                //取回會員物件並將登入狀態存入偏好設定
//                var memberInfo: Member? = nil
                Communicator.shared.findMemberByAccountAndPassword(name: account, password: password, completion: { (memberResult, error) in
                    print("memberResult: \(memberResult)")
                    guard let memberResult = memberResult else {
                        assertionFailure("findMemberByAccountAndPassword fail.")
                        return
                    }
                    //memberInfo = try? decoder.decode(Member.self, from: memberResult)
                    print("memberResult!: \(memberResult)")
                })
                
                
                UserDefaults.standard.set(true, forKey: "isLogin")
               
                //關閉登入畫面
                
                
            } else {
                let alertController = UIAlertController(title: "登入", message:
                    "登入失敗，請確認輸入的帳密是否正確並重新輸入！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    //會員註冊
    @IBAction func registerBtnPressed(_ sender: UIButton) {
    
    }
    
   
}

extension Communicator {
    func isUserValid(name: String, password: String, completion: @escaping DoneHandler) -> Bool {
        let isUserValid = false
        let parameters: [String: Any] = [ACTION_KEY: "isUserValid", ACCOUNT_KEY: name, PASSWORD_KEY: password]
        doPost(urlString: MEMBERSERVLET_URL, parameters: parameters, completion: completion)
        return isUserValid
    }
    
    func findMemberByAccountAndPassword(name: String, password: String, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "findMemberByAccountAndPassword", ACCOUNT_KEY: name, PASSWORD_KEY: password]
        doPost(urlString: MEMBERSERVLET_URL, parameters: parameters, completion: completion)
    }
}
