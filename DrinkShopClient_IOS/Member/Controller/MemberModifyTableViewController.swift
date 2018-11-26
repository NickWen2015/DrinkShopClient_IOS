//
//  MemberModifyTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/19.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class MemberModifyTableViewController: UITableViewController {
    var member: Member?
    var member_id_value = 0
    var member_account_value = ""
    var member_password_value = ""
    var confrim_member_password_value = ""
    var member_name_value = ""
    var member_sex_value = ""
    var member_birthday_value = ""
    var member_mobile_value = ""
    var member_email_value = ""
    var member_address_value = ""
    var member_sex_SegmentedControl_temp = ""
    
    let communicator = Communicator.shared
    
    @IBOutlet weak var member_account_TextField: UITextField!
    @IBOutlet weak var member_password_TextField: UITextField!
    @IBOutlet weak var confrim_member_password_TextField: UITextField!
    @IBOutlet weak var member_name_TextField: UITextField!
    @IBOutlet weak var member_sex_SegmentedControl: UISegmentedControl!
    @IBOutlet weak var member_birthday_DatePicker: UIDatePicker!
    @IBOutlet weak var member_mobile_TextField: UITextField!
    @IBOutlet weak var member_email_TextField: UITextField!
    @IBOutlet weak var member_address_TextField: UITextField!
    
    @IBOutlet weak var savaBarButtonItem: UIBarButtonItem!
    
    var login: Login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //取用member_id取回會員物件
        //將登入狀態存入偏好設定
        //取偏好設定判斷是否已登入
        guard let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool, let member_id = UserDefaults.standard.value(forKey: "member_id") as? Int, let member_name = UserDefaults.standard.value(forKey: "member_name") as? String else {
            assertionFailure("UserDefaults isLogin or member_id or member_name is nil")
            return
        }
        login = Login(view: self)
        
        if(isLogin){
            //將會員ID取出偏好設定
            communicator.getMemberById(member_id: "\(member_id)") { (result, error) in
                if let error = error {
                    print("getMemberById fail: \(error)")
                    return
                }
                
                //Decode as Member.
                guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                    print("Fail to generate jsonData.")
                    return
                }
                
                let decoder = JSONDecoder()
                guard let memberObject = try? decoder.decode(Member.self, from: jsonData)else {
                    print("Fail to decode jsonData.")
                    return
                }
                
                self.member_account_TextField.isEnabled = false//帳號不可編輯，為唯一值
                self.member_account_TextField.text = memberObject.member_account
                self.member_password_TextField.text = memberObject.member_password
                self.confrim_member_password_TextField.text = memberObject.member_password
                self.member_name_TextField.text = memberObject.member_name
                let sexValue = memberObject.member_sex
                switch sexValue {
                case "1":// 男生
                    self.member_sex_SegmentedControl.selectedSegmentIndex = 0
                case "0":// 女生
                    self.member_sex_SegmentedControl.selectedSegmentIndex = 1
                default:
                    self.member_sex_SegmentedControl.selectedSegmentIndex = 0
                }
                let member_birthday = Common.getDateFromString(strFormat: "yyyy-MM-dd", strDate: memberObject.member_birthday)
                print("date : \(member_birthday)")
                
                self.member_birthday_DatePicker.date = member_birthday
                self.member_mobile_TextField.text = memberObject.member_mobile
                self.member_email_TextField.text = memberObject.member_email
                self.member_address_TextField.text = memberObject.member_address
                
                self.member_id_value = memberObject.member_id
                self.member_account_value = memberObject.member_account
                self.member_password_value = memberObject.member_password
                self.confrim_member_password_value = memberObject.member_password
                self.member_name_value = memberObject.member_name
                self.member_sex_value = memberObject.member_sex
                self.member_birthday_value = memberObject.member_birthday
                self.member_mobile_value = memberObject.member_mobile
                self.member_email_value = memberObject.member_email
                self.member_address_value = memberObject.member_address
            }
        }else{
            print("未登入")
            //呼叫登入畫面
            login.login()
        }
        
        savaBarButtonItem.isEnabled = false
    }
    
    
    
    @IBAction func editingChangedBarButtonItemEnabled(_ sender: Any) {
        campareEditingValue()
    }
    
    //檢查是否欄位值有更改才能儲存
    func campareEditingValue() {
       
        if self.member_sex_SegmentedControl.selectedSegmentIndex == 0 {// 男生
            member_sex_SegmentedControl_temp = "1"
        }else {// 女生
            member_sex_SegmentedControl_temp = "0"
        }
        
        
       if self.member_password_TextField.text != self.member_password_value ||
          self.confrim_member_password_TextField.text != self.confrim_member_password_value ||
          self.member_name_TextField.text != self.member_name_value ||
          member_sex_SegmentedControl_temp != self.member_sex_value ||
          self.member_birthday_DatePicker.date != Common.getDateFromString(strFormat: "yyyy-MM-dd", strDate: self.member_birthday_value) ||
          self.member_mobile_TextField.text != member_mobile_value ||
          self.member_email_TextField.text != member_email_value ||
          self.member_address_TextField.text != member_address_value {
            savaBarButtonItem.isEnabled = true
        } else {
            savaBarButtonItem.isEnabled = false
        }
    }
    
   
    
    //保存會員資料
    @IBAction func saveBarBtnPressed(_ sender: UIBarButtonItem) {
        
        let member_password: String = member_password_TextField.text!
        let confrim_member_password: String = confrim_member_password_TextField.text!
        let member_name: String = member_name_TextField.text!
        let member_mobile: String = member_mobile_TextField.text!
        let member_email: String = member_email_TextField.text!
        let member_address: String = member_address_TextField.text!
        
        print("member_password: \(member_password)")
        print("confrim_member_password: \(confrim_member_password)")
        
        guard member_password == confrim_member_password else {
            let alertController = UIAlertController(title: "密碼不符合", message:
                "請確認兩次密碼是否輸入相同", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        guard member_password.count != 0 &&
            confrim_member_password.count != 0 &&
            member_name.count != 0 &&
            member_mobile.count != 0 &&
            member_email.count != 0 &&
            member_address.count != 0 else {
                let alertController = UIAlertController(title: "資料不齊全", message:
                    "請確認輸入資料是否完整", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                return
        }
       
        
        let member = Member(
            member_id: member_id_value,
            member_account: member_account_value,
            member_password: member_password,
            member_name: member_name,
            member_birthday: Common.getStringFromDate(strFormat: "yyyy-MM-dd", date:  self.member_birthday_DatePicker.date),
            member_sex: member_sex_SegmentedControl_temp,
            member_mobile: member_mobile,
            member_email: member_email,
            member_address: member_address,
            member_status: "1"
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let memberData = try? encoder.encode(member) else {
            assertionFailure("Cast member to json is Fail.")
            return
        }
        
        print(String(data: memberData, encoding: .utf8)!)

        guard let memberString = String(data: memberData, encoding: .utf8) else {
            assertionFailure("Cast memberData to String is Fail.")
            return
        }
        
        //寫入資料庫
        communicator.memberUpdate(member: memberString) { (result, error) in
            if let error = error {
                print("memberUpdate fail: \(error)")
                return
            }
        
            guard let loginStatus = result as? Int else {
                assertionFailure("modify fail.")
                return
            }
            
            
            if loginStatus == 1 {
                //跳出登入成功視窗
                let alertController = UIAlertController(title: "完成", message:
                    "儲存成功！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: false, completion: nil)
                
                //相關欄位存入偏好設定
                self.login.setUserDefaultsLogin(member_id: self.member_id_value, member_name: member_name)
                
//                self.tableView.reloadData()
                
                //儲存按鈕消失
                self.savaBarButtonItem.isEnabled = false
            } else {
                let alertController = UIAlertController(title: "失敗", message:
                    "儲存失敗，請確認輸入資料否正確！", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
