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
            }
        }else{
            print("未登入")
            //呼叫登入畫面
            login.login()
        }
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
