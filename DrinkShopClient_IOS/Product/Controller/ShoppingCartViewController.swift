//
//  ShoppingCartViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/4.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {
    
    
    
    let logSQLite = LogSQLite.init()  // 資料庫
    
    @IBOutlet weak var takeOutButton: UIButton!
    @IBOutlet weak var orderInButton: UIButton!
    @IBOutlet weak var useCouponButton: UIButton!
    @IBOutlet weak var totalCapLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    private var order_type = "0" // 訂單類型預設為 自取
    
    var shoppingCarContent: ShoppingCart!
    static var ShoppingCartTableVC: ShoppingCartTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingCartTableViewController.ShoppingCartVC = self
        setTotalCapAndTotalAmount()
        
        UiHelper.setCornerRadius(view: takeOutButton)
        UiHelper.setCornerRadius(view: orderInButton)
        UiHelper.setBorder(view: takeOutButton, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        UiHelper.setBorder(view: orderInButton, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        ShoppingCartViewController.ShoppingCartTableVC = nil
    }
    
    // 選擇訂單類別 自取/外送
    @IBAction func selectOrderType(_ sender: UIButton) {
        order_type = String(sender.tag)
        
        if order_type == "0" {
            UiHelper.setBorder(view: takeOutButton, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
            UiHelper.setBorder(view: orderInButton, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        } else {
            UiHelper.setBorder(view: orderInButton, color: #colorLiteral(red: 0.5316327214, green: 0.820274055, blue: 1, alpha: 1))
            UiHelper.setBorder(view: takeOutButton, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShoppingCartGoAddingProduct" {
            let addingProduct = segue.destination as! AddingProductToShoppingCartViewController
            guard (shoppingCarContent != nil) else {
                return
            }
            let id = shoppingCarContent.getId()
            let product_id = shoppingCarContent.getProductId()
            let product = logSQLite.searchProductPriceInId(product_id)
            let category = shoppingCarContent.getCategory()
            let productName = shoppingCarContent.getProductName()
            let priceM = product.getPriceM()
            let priceL = product.getPriceL()
            let size = shoppingCarContent.getSize()
            let sugar = shoppingCarContent.getSugar()
            let temperature = shoppingCarContent.getTemperature()
            let from = "ShoppingCartViewController"
            let quantity = shoppingCarContent.getQuantity()
            
            addingProduct.id = id
            addingProduct.product_id = product_id
            addingProduct.category = category
            addingProduct.productName = productName
            addingProduct.priceM = priceM
            addingProduct.priceL = priceL
            addingProduct.size = size
            addingProduct.sugar = sugar
            addingProduct.temperature = temperature
            addingProduct.from = from
            addingProduct.quantity = quantity
            
        }
    }
    
    @IBAction func unwindToShoppingCartViewController(_ unwindSegue: UIStoryboardSegue) {
        // 刷新 ShoppingCartTableVC 的 tableView
        ShoppingCartViewController.ShoppingCartTableVC.tableView.reloadData()
        setTotalCapAndTotalAmount()
    }

}

// MARK: - Common Method
extension ShoppingCartViewController {
    
    // 設定總金額及總杯數
    func setTotalCapAndTotalAmount() {
        var totalCap = 0
        var totalAmount = 0
        let shoppingCartTotals = logSQLite.searchTotalCapAndTotalAmount()
        for shoppingCartTotal in shoppingCartTotals {
            let quantity = shoppingCartTotal.getQuantity()
            let price = shoppingCartTotal.getPrice()
            
            totalCap += quantity
            totalAmount += quantity * price
        }
        totalCapLabel.text = "\(totalCap) 杯"
        totalAmountLabel.text = "\(totalAmount) 元"
        
    }
}
