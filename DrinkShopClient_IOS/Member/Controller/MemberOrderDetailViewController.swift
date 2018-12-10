//
//  StatusDetailViewController.swift
//  DSS
//
//  Created by Lucy on 2018/12/4.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MemberOrderDetailViewController: UIViewController {
    var order: Order?
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderAcceptDateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderDetailTextView: UITextView!
    @IBOutlet weak var orderTypeBtn: UIButton!
    
    @IBOutlet weak var totalCountLabel: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //產生QRcode圖片
        guard let url = URL(string: "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=\(String(describing: order?.order_id))") else {
            assertionFailure("Invliad url.")
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) {(data, response, error) in
            if let error = error {
                print("Download fail: \(error)")
                return
            }
            guard let data = data else {
                assertionFailure("data is nil.")
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.qrCodeImage.image = image
            }
        }
        task.resume()
        
        
        
        
        guard CLLocationManager.locationServicesEnabled() else {//檢查user是否有啟用定位服務
            // show alert to user.
            return
        }
        // Ask permission
        // locationManager.requestWhenInUseAuthorization()//僅使用app期間取得位置
        locationManager.requestAlwaysAuthorization()//永遠允許取得位置,包含app在背景狀態
        
        // Prepare locationManager
        locationManager.delegate = self as! CLLocationManagerDelegate// Important!指定回報對象為ViewController自己
        locationManager.desiredAccuracy = kCLLocationAccuracyBest// 指定渴望的精確度
        locationManager.activityType = .fitness// fitness運動模式,CLActivityType預設為other
        locationManager.startUpdatingLocation() //更新位置
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "orderBG")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        guard let order = order else {
            assertionFailure("order is nil.")
            return
        }
        
        let discount = order.coupon_discount == 0 ? 10.0 : order.coupon_discount
        let orderDetailList = order.orderDetailList
        var tatol_product_quantity = 0
        var subTatolPrice = 0
        var tatolPrice = 0
        var formatText = ""
        for item in orderDetailList {
            subTatolPrice = Int(item.product_price) * item.product_quantity
            tatolPrice += subTatolPrice
            tatol_product_quantity += item.product_quantity
            formatText += item.product_name + " "
                + item.sugar_name + " "
                + item.ice_name + " "
                + item.size_name + " "
                + String(item.product_quantity) + "杯 "
                + String(subTatolPrice) + "元\n"
        }
        
        tatolPrice = Int(Double(tatolPrice) * (discount/10))
        if discount != 10.0 {
            formatText += "已使用\(discount)折卷"
        }
        orderIdLabel.text = String(order.order_id)
        orderAcceptDateLabel.text = order.order_accept_time
        totalPriceLabel.text = String(tatolPrice) + "元"
        orderDetailTextView.text = formatText
        totalCountLabel.text = String(tatol_product_quantity) + "杯"
        if order.order_type == "0" {
            orderTypeBtn.setTitle("自取", for: .normal)
            orderTypeBtn.isEnabled = true
        } else {
            orderTypeBtn.setTitle("外送", for: .normal)
            orderTypeBtn.isEnabled = false
            orderTypeBtn.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
            
        }
    }
    
    @IBAction func orderTypeBtnPressed(_ sender: UIButton) {
        
        guard let order = order else {
            assertionFailure("order is nil.")
            return
        }
        guard let latitude = Double(order.store_location_x), let longitude = Double(order.store_location_y) else {
            assertionFailure("cast  store_location_x or store_location_y to double is fail.")
            return
        }
        
        // 取得user現在位置
        guard let location = locationManager.location else { // locationManager.location拿到最後位置
            print("Location is not ready.")
            return
        }
       
       //設定座標
       let lat = CLLocationDegrees(latitude)
       let long = CLLocationDegrees(longitude)
       let storeLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
       let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
       
       //由座標取住址
        let myAddress = MKPlacemark(coordinate: myLocation, addressDictionary: nil)
        let storeAddress = MKPlacemark(coordinate: storeLocation, addressDictionary: nil)
        
        //set Map item
        let myItem = MKMapItem(placemark: myAddress)
        let storeItem = MKMapItem(placemark: storeAddress)
        
        myItem.name = UserDefaults.standard.value(forKey: "member_name") as? String
        storeItem.name = order.store_name
        
        let routes = [myItem, storeItem]
        
        //set navigation mode.
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        //open map and begin navigation.
        MKMapItem.openMaps(with: routes, launchOptions: options)
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


// MARK: - CLLocationManagerDelegate Methods.
extension MemberOrderDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else{//locations.last?有可能會取到空值
            assertionFailure("Invalid coordinate or location.")//debug比較好用
            return
        }
        print("Current Location: \(coordinate.latitude), \(coordinate.longitude)")//latitude緯度,longitude經度
    }
}
