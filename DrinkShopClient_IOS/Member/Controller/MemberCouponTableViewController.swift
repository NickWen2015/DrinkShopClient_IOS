//
//  MemberCouponTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/21.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit
import Lottie

class MemberCouponTableViewController: UITableViewController {
    
    var objects = [Coupon]()
    let communicator = Communicator.shared
    @IBOutlet weak var addCouponBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addCouponBarBtn.isEnabled = false//預設無法按
        
        guard let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool, let member_id = UserDefaults.standard.value(forKey: "member_id") as? Int else {
            assertionFailure("member is not login or member_id is nil")
            return
        }
        
        if(isLogin){
            let id = String(member_id)
            communicator.getAllCouponsByMemberId(member_id: id){ (result, error) in
                if let error = error {
                    print(" Load Data Error: \(error)")
                    return
                }
                guard let result = result else {
                    print (" result is nil")
                    return
                }
                print("Load Data OK.")
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                    print(" Fail to generate jsonData.")
                    return
                }
                //解碼
                let decoder = JSONDecoder()
                guard let resultObject = try? decoder.decode([Coupon].self, from: jsonData) else {
                    print(" Fail to decode jsonData.")
                    return
                }
                self.addCouponBarBtn.isEnabled = true
                for couponItem in resultObject {
                    if couponItem.coupon_status == "0" {
                        self.addCouponBarBtn.isEnabled = false
                    }
                    self.objects.append(couponItem)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                if self.objects.count == 0 {
                    //沒有優惠卷資料
                    let alertController = UIAlertController(title: "無資料", message:
                        "您沒有優惠卷！", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: false, completion: nil)
                    self.addCouponBarBtn.isEnabled = true
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        objects.removeAll()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! MemberCouponTableViewCell
        
        cell.starTimeLabel?.text = objects[indexPath.row].coupon_start
        cell.endTimeLabel?.text = objects[indexPath.row].coupon_end
        cell.useLabel?.text = objects[indexPath.row].coupon_status == "0" ? "未使用" : "已使用"
        let text_temp = String(objects[indexPath.row].coupon_discount)
        let i = text_temp.index(text_temp.startIndex, offsetBy: 0)
        let text = String(text_temp[i])
        cell.discountLabel?.text = text + "折"
        if (cell.useLabel?.text == "已使用" ){
            cell.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
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
