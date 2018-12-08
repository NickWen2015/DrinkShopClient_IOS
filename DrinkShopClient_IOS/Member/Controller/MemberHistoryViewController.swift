//
//  OrderDetailViewController.swift
//  DS
//
//  Created by Lucy on 2018/12/4.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class MemberHistoryViewController: UIViewController {

    var order: Order?
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderAcceptDateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderDetailTextView: UITextView!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var orderTypeImageView: UIImageView!
    @IBOutlet weak var totalCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "orderHistoryBG")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        guard let order = order else {
            assertionFailure("order is nil.")
            return
        }
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
        orderIdLabel.text = String(order.order_id)
        orderAcceptDateLabel.text = order.order_accept_time
        totalPriceLabel.text = String(tatolPrice) + "元"
        orderDetailTextView.text = formatText
        if order.order_type == "0" {
            orderTypeLabel.text = "自取"
            orderTypeImageView.image = UIImage(named: "goToStore")
        } else {
            orderTypeLabel.text = "外送"
            orderTypeImageView.image = UIImage(named: "delivery")
        }
        totalCountLabel.text = String(tatol_product_quantity) + "杯"
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
