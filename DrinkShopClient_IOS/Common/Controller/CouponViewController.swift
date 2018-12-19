//
//  ViewController.swift
//  LottieDemo
//
//  Created by Nick Wen on 2018/12/10.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit
import Lottie

class CouponViewController: UIViewController {
    
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var getCouponBtn: UIButton!
    
    var from: String!
    
    let communicator = Communicator.shared
    var member_id: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let member_id_temp = UserDefaults.standard.value(forKey: "member_id") as? Int else {
            assertionFailure("UserDefaults member_id is nil.")
            return
        }
        member_id = member_id_temp
    }

    @IBAction func couponBtnPressed(_ sender: UIButton) {
        
        if member_id != 0 {
            
            let coupon = generateCoupon(member_id: member_id)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            guard let couponData = try? encoder.encode(coupon) else {
                assertionFailure("Cast coupon to json is Fail.")
                return
            }
            
            print(String(data: couponData, encoding: .utf8)!)
            
            guard let couponString = String(data: couponData, encoding: .utf8) else {
                assertionFailure("Cast couponData to String is Fail.")
                return
            }
            
            //寫入資料庫
            communicator.couponInsert(coupon: couponString) { (result, error) in
                if let error = error {
                    print("couponInsert fail: \(error)")
                    return
                }
                
                guard let result = result as? Int else {
                    assertionFailure("Insert fail.")
                    return
                }
                
                if result == 1 {
                    //儲存按鈕消失
                    self.getCouponBtn.isEnabled = false
                } else {
                    let alertController = UIAlertController(title: "失敗", message:
                        "儲存失敗，請確認輸入資料否正確！", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
            }
            
            let discountText = String(coupon.coupon_discount)
            let alertController = UIAlertController(title: "恭喜", message:
                "恭喜您獲得\(discountText)折優惠卷！", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            discountLabel.text = "恭喜您獲得\(discountText)折優惠卷！"
            
            if from == "Shop" {
                //存取優惠卷時間
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateNow = formatter.string(from: date)
                UserDefaults.standard.set(dateNow, forKey: "dateNowStamp")
            }
        }
       
    }
    
    //產生優惠卷
    func generateCoupon(member_id: Int) -> Coupon {
        playAnimationView()
        let coupon: Coupon
        let discount = Int.random(in: 1...9)
        let coupon_discount = Double(discount)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateNow = formatter.string(from: date)
        
        coupon = Coupon(coupon_id: 0,
                            member_id: member_id,
                            coupon_no: "123",
                            coupon_discount: coupon_discount,
                            coupon_status: "0",
                            coupon_start: dateNow,
                            coupon_end: "2019-01-21")        
        return coupon
    }
    
    //播放動畫
    func playAnimationView() {
        let animationView = LOTAnimationView(name: "servishero_loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        
        animationView.play()
    }
    
}

