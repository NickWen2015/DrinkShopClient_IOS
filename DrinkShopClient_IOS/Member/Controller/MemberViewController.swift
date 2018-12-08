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
    var member: Member?
    var login: Login!
    
    let communicator = Communicator.shared

    
    override func viewDidLoad() {
       super.viewDidLoad()
       login = Login(view: self)
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
        
       communicator.isUserValid(name: account, password: password) {result, error in
            
            print("result: \(result ?? ""))")
        
            if let error = error {
                print("isUserValid fail: \(error)")
                return
            }
        
            guard let loginStatus = result as? Int else {
                assertionFailure("login fail.")
                return
            }
            
            
            if loginStatus == 1 {
                //跳出登入成功視窗
                let alertController = UIAlertController(title: "登入", message:
                    "登入成功！", preferredStyle: UIAlertController.Style.alert)
                self.present(alertController, animated: false, completion: nil)
                
                //取回會員物件
                self.communicator.findMemberByAccountAndPassword(name: account, password: password, completion: { (memberJson, error) in
                    
                    if let error = error {
                        print("findMemberByAccountAndPassword fail: \(error)")
                        return
                    }
                    
                    
                    guard let memberJson = memberJson as? [String: Any] else {
                        assertionFailure("Invalid memberJson object.")
                        return
                    }
                    
                    
                    //Decode as Member.
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: memberJson, options: .prettyPrinted) else {
                        print("Fail to generate jsonData.")
                        return
                    }

                    let decoder = JSONDecoder()
                    guard let memberObject = try? decoder.decode(Member.self, from: jsonData)  else {
                        print("Fail to decode jsonData.")
                        return
                    }
                    let member_id = memberObject.member_id
                    let member_name = memberObject.member_name
                    let member_sex = memberObject.member_sex
                    //將登入狀態存入偏好設定
                    self.login.setUserDefaultsLogin(member_id: member_id, member_name: member_name, member_sex: member_sex)
                    
//                    self.member = memberObject
                    //開逃生門到會員頁
                    self.performSegue(withIdentifier: "CancelForMemberFunction", sender: self)
                    return
                })
                
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
    
    @IBAction func cancelBarBtnPressed(_ sender: UIBarButtonItem) {
        //開逃生門到活動頁
        PrintHelper.println(tag: "MemberViewController", line: #line, "cancelBarBtnPressed.")
        self.performSegue(withIdentifier: "CancelForActivities", sender: self)
    }
    
}


