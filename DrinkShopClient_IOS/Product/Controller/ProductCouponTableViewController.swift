//
//  ProductCouponTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/10.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class ProductCouponTableViewController: UITableViewController {
    
    static var shoppingCartVC: ShoppingCartViewController!
    
    var objects = [Coupon]()
    let communicator = Communicator.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let isLogin = UserDefaults.standard.value(forKey: "isLogin") as? Bool, let member_id = UserDefaults.standard.value(forKey: "member_id") as? Int else {
            assertionFailure("member is not login or member_id is nil")
            return
        }
        
        communicator.getCouponsByMemberId(useStatus: "0", memberId: member_id) { (result, error) in
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
            for couponItem in resultObject {
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
            }
            
        }
        
    }
    
    // MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! ProductCouponTableViewCell
        
        cell.startTimeLabel?.text = objects[indexPath.row].coupon_start
        cell.endTimeLabel?.text = objects[indexPath.row].coupon_end
        let text_temp = String(objects[indexPath.row].coupon_discount)
        let i = text_temp.index(text_temp.startIndex, offsetBy: 0)
        let text = String(text_temp[i])
        cell.discountLabel?.text = text + "折"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delegate = ProductCouponTableViewController.shoppingCartVC
        delegate?.fetchData(coupon: objects[indexPath.row])
    }

}

extension Communicator {
    func getCouponsByMemberId(useStatus: String, memberId: Int, completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "getCouponsByMemberId", COUPON_STATUS_KEY: useStatus, MEMBER_ID_KEY: memberId]
        doPost(urlString: COUPONSERVLET_URL, parameters: parameters, completion: completion)
    }
}
