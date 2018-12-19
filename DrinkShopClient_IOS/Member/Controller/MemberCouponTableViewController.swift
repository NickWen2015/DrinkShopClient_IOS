//
//  MemberCouponTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/11/21.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit
import Lottie
import CoreLocation

class MemberCouponTableViewController: UITableViewController {
    
    var from = ""
    
    var objects = [Coupon]()
    let communicator = Communicator.shared
    @IBOutlet weak var addCouponBarBtn: UIBarButtonItem!
    
    // beacon
    let beaconUUID = UUID(uuidString: "74278BDA-B655-4520-8F0C-720EAF059935")
    var beaconRegion: CLBeaconRegion!
    
    let manager = CLLocationManager()
    // /beacon
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // beacon
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        
        // Prepare beaconRegion
        beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID!, identifier: "Beacon")
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        
        // /beacon
    }
    
    // beacon
    override func viewWillDisappear(_ animated: Bool) {
        manager.stopMonitoring(for: beaconRegion)
        manager.stopRangingBeacons(in: beaconRegion)
    }
    // /beacon
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.startMonitoring(for: beaconRegion)
        
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
                
                self.addCouponBarBtn.isEnabled = false
                for couponItem in resultObject {
//                    if couponItem.coupon_status == "0" {
//                        self.addCouponBarBtn.isEnabled = false
//                    }
                    self.objects.append(couponItem)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                if self.objects.count == 0 {
                    let alertController = UIAlertController(title: "沒有優惠卷！", message:
                        "", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: false, completion: nil)
                    self.addCouponBarBtn.isEnabled = true
                    self.from = "noCoupon"
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
       
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let couponVC = segue.destination as! CouponViewController
        couponVC.from = from
        
    }
 

}


extension MemberCouponTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        //存取優惠卷時間
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateNow = formatter.string(from: date)
      
        if let dateNowStamp = UserDefaults.standard.value(forKey: "dateNowStamp") as? String {
            print("dateNowStamp is : \(dateNowStamp).")
            print("dateNow is : \(dateNow).")
            if dateNowStamp != dateNow {
                checkStatus(manager: manager, state: state, region: region)
            }
        } else {//When dateNowStamp is nil.
            print("dateNowStamp is nil.")
            checkStatus(manager: manager, state: state, region: region)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            switch beacon.proximity {
            case .unknown:
                addCouponBarBtn.isEnabled = false
                break
            case .immediate:
                addCouponBarBtn.isEnabled = true
                break
            case .near:
                addCouponBarBtn.isEnabled = true
                break
            case .far:
                addCouponBarBtn.isEnabled = true
                break
            }            
        }
        
        
    }
    
    func checkStatus(manager: CLLocationManager, state: CLRegionState,  region: CLRegion) {
        if state == .inside {
            let alertController = UIAlertController(title: "恭喜獲得抽獎機會\n快按右上角的+來抽獎吧！", message:
                "", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: false, completion: nil)
            from = "Shop"
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
        } else {  // .outside
            manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
    }
}
