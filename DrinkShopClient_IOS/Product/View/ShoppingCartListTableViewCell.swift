//
//  ShoppingCartListTableViewCell.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/4.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class ShoppingCartListTableViewCell: UITableViewCell {
    
    let logSQLite = LogSQLite.init()  // 資料庫
    
    @IBOutlet weak var shoppingCartBackground: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var sizeSugarTemperatureLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // 必須給值
    var tableView: UITableView!
    var shoppingCartViewController: ShoppingCartViewController!
    var shoppingCarContent: ShoppingCart? {
        didSet {
            let productName = "\(shoppingCarContent!.getProductName())"
            let quantity = shoppingCarContent!.getQuantity()
            let price = shoppingCarContent!.getSizePrice()
            let subtotal = "\(quantity * price)"
            let size = ProductDetails.valueOfSize(size: shoppingCarContent!.getSize())
            let sugar = ProductDetails.valueOfSugar(suger: shoppingCarContent!.getSugar())
            let temperature = ProductDetails.valueOfTemperature(temperature: shoppingCarContent!.getTemperature())
            let sizeSugarTemperature = "\(size)" + "/\(sugar)" + "/\(temperature)"
            
            productNameLabel.text = productName
            quantityLabel.text = "數量：\(quantity)"
            priceLabel.text = "單價：\(price)"
            subtotalLabel.text = "小計：\(subtotal)"
            sizeSugarTemperatureLabel.text = sizeSugarTemperature
        }
    }
    
    @IBAction func selectEditButton(_ sender: UIButton) {
        guard let shoppingCarContent = shoppingCarContent else {
            return
        }
        // 注意 先給值再轉頁
        shoppingCartViewController.shoppingCarContent = shoppingCarContent
        
        shoppingCartViewController.performSegue(withIdentifier: "ShoppingCartGoAddingProduct", sender: nil)
        
    }
    
    @IBAction func selectDeleteButton(_ sender: UIButton) {
        PrintHelper.println(tag: "ShoppingCartListTableViewCell", line: #line, "刪除 ID: \(shoppingCarContent!.getId()) 商品名稱： \(shoppingCarContent!.getProductName())")
        logSQLite.deleteSelectProduct(id: shoppingCarContent!.getId())
        tableView.reloadData()
        shoppingCartViewController.setTotalCapAndTotalAmount()
        shoppingCartViewController.setShoppingCartListHiddenStatus()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        UiHelper.setCornerRadius(view: shoppingCartBackground)
        UiHelper.setCornerRadius(view: productImageView)
        UiHelper.setCornerRadius(view: editButton)
        UiHelper.setCornerRadius(view: deleteButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
