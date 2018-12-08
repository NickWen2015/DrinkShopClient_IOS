//
//  MemberRegisterTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/12/8.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class MemberRegisterTableViewController: UITableViewController {

    
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
    @IBOutlet weak var birthdayDateLabel: UILabel!
    
    @IBOutlet weak var savaBarButtonItem: UIBarButtonItem!
    var login: Login!
    override func viewDidLoad() {
        super.viewDidLoad()
        member_birthday_DatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        savaBarButtonItem.isEnabled = false
    }
    
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        let dateformatter = DateFormatter()
        //自定義日期格式
        dateformatter.dateFormat = "yyyy-MM-dd"
        let birthdayDateValue = dateformatter.string(from: member_birthday_DatePicker.date)
        birthdayDateLabel.text = birthdayDateValue
    }

    
    @IBAction func editingChangedBarButtonItemEnabled(_ sender: Any) {
         self.savaBarButtonItem.isEnabled = true
    }
    
    
    //保存會員資料
    @IBAction func saveBarBtnPressed(_ sender: UIBarButtonItem) {
        
        let member_account = member_account_TextField.text!
        let member_password: String = member_password_TextField.text!
        let confrim_member_password: String = confrim_member_password_TextField.text!
        let member_name: String = member_name_TextField.text!
        let member_mobile: String = member_mobile_TextField.text!
        let member_email: String = member_email_TextField.text!
        let member_address: String = member_address_TextField.text!
        let member_birthday: String = birthdayDateLabel.text!
        
        guard member_password == confrim_member_password else {
            let alertController = UIAlertController(title: "密碼不符合", message:
                "請確認兩次密碼是否輸入相同", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        guard member_account.count != 0 &&
            member_password.count != 0 &&
            confrim_member_password.count != 0 &&
            member_name.count != 0 &&
            member_birthday.count != 0 &&
            member_mobile.count != 0 &&
            member_email.count != 0 &&
            member_address.count != 0 else {
                let alertController = UIAlertController(title: "資料不齊全", message:
                    "請確認輸入資料是否完整", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                return
        }
        
        
        
        var member_sex = "0"
        if member_sex_SegmentedControl.selectedSegmentIndex == 0 {
            member_sex = "1"
        }
        
        let member = Member(
            member_id: 0,
            member_account: member_account,
            member_password: member_password,
            member_name: member_name,
            member_birthday: member_birthday,
            member_sex: member_sex,
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
        communicator.memberInsert(member: memberString) { (result, error) in
            if let error = error {
                print("memberUpdate fail: \(error)")
                return
            }
            
            guard let result = result as? Int else {
                assertionFailure("modify fail.")
                return
            }
            
            
            if result == 1 {
                //儲存按鈕消失
                self.savaBarButtonItem.isEnabled = false
                self.dismiss(animated: true)
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
