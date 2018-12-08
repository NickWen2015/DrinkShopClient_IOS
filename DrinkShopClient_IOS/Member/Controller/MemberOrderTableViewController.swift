//
//  MemberOrderTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/21.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class MemberOrderTableViewController: UITableViewController {

    var objects = [Order]()
    let communicator = Communicator.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //檢查是否登入才撈訂單
        guard let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool, let member_id = UserDefaults.standard.value(forKey: "member_id") as? Int else {
            assertionFailure("member is not login or member_id is nil")
            return
        }
        
        if(isLogin){
            let id = String(member_id)
            communicator.findOrderByMemberId(member_id: id){ (result, error) in
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
                guard let resultObject = try? decoder.decode([Order].self, from: jsonData) else {
                    print(" Fail to decode jsonData.")
                    return
                }
                for item in resultObject {
                    self.objects.append(item)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                if self.objects.count == 0 {
                    //沒有訂單資料
                    let alertController = UIAlertController(title: "無資料", message:
                        "您沒有訂單資料！", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: false, completion: nil)
                }
            }
        }
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! MemberOrderTableViewCell
        
        let orderDetailList = objects[indexPath.row].orderDetailList
        var tatol_product_quantity = 0
        var tatolPrice = 0
        for item in orderDetailList {
            tatolPrice += Int(item.product_price) * item.product_quantity
            tatol_product_quantity += item.product_quantity
        }
        cell.orderIdLabel?.text = String(objects[indexPath.row].order_id)
        cell.orderTotalPriceLabel?.text = String(tatolPrice) + "元"
        cell.orderQuantityLabel?.text = String(tatol_product_quantity) + "杯"
        cell.orderAcceptDateLabel?.text = objects[indexPath.row].order_accept_time
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 看看使用者選到了哪一個 indexPath
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let order = objects[selectedIndexPath.row]
            
            // 取得下一頁
            let memberOrderVC = segue.destination as!
            MemberOrderDetailViewController
            
            memberOrderVC.order = order
        }
    }

}
