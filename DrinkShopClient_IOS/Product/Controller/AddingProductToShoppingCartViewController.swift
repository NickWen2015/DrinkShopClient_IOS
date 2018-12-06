//
//  AddingProductToShoppingCartViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/20.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

extension AddingProductToShoppingCartViewController: AddingProductToShoppingCartFetchDataDelegate {
    func fetchData(size: Int, sugar: Int, temperature: Int) {
        self.size = size + 1
        self.sugar = sugar + 1
        self.temperature = temperature + 1
    }
}

class AddingProductToShoppingCartViewController: UIViewController {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var backQuantityButton: UIButton!
    @IBOutlet weak var addQuantityButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    static var AddingProductTableVC: AddingProductToShoppingCartTableViewController!
    var delegate: AddingProductToShoppingCartTableFetchDataDelegate!
    let logSQLite = LogSQLite.init()  // 資料庫
    
    var from: String!
    var quantity: Int!

    // 從ProductPage利用prepare傳送過來的資料
    var id: Int!
    var product_id: Int!
    var category: String!
    var productName: String!
    var priceM: Int!
    var priceL: Int!
    
    // 從addingProductTable利用Delegat傳送過來的資料
    var size: Int!
    var sugar: Int!
    var temperature: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = AddingProductToShoppingCartViewController.AddingProductTableVC
        self.delegate?.fetchData(size: size, sugar: sugar, temperature: temperature)
        AddingProductToShoppingCartTableViewController.AddingProductVC = self
        productNameLabel.text = productName
        
        guard let quantity = quantity else {
            PrintHelper.println(tag: "AddingProductToShoppingCartViewController", line: #line, "ERROR: quantity is nil")
            return
        }
        quantityLabel.text = String(quantity)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        AddingProductToShoppingCartViewController.AddingProductTableVC = nil
    }
    
    // ------- //

    @IBAction func addOrBackQuantity(_ sender: UIButton) {
        if sender.tag == 0 {
            giveQuantity(label: quantityLabel, -1)
        } else {
            giveQuantity(label: quantityLabel, 1)
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        let product_quantity = getQuantity()
        let sizePrice = getSizePrice()
        
        guard let productId = product_id,
        let category = category,
        let productName = productName else {
            PrintHelper.println(tag: "AddingProductToShoppingCartViewController", line: #line, "ERROR: product_id, category, productName is nil.")
            return
        }
        
        let newProduct = ShoppingCart(productId: productId, category: category, productName: productName, size: size, sizePrice: sizePrice, quantity: product_quantity, sugar: sugar, temperature: temperature)
        
        if from == "ProductPageViewController" {
            logSQLite.appendSelectProduct(newProduct)
        } else if from == "ShoppingCartViewController" {
            logSQLite.updateSelectProduct(id: id, sc: newProduct)
        }
        unwindToPreviousPage()
        
    }
    
    // 判斷使用者選取的商品多少錢
    func getSizePrice() -> Int {
        if size == 1 {
            return priceM
        } else {
            return priceL
        }
    }
    
    // TODO: - get Quantity
    func getQuantity() -> Int {
        guard let quantityString = quantityLabel.text,
            let product_quantity = Int(quantityString) else {
                PrintHelper.println(tag: "AddingProductToShoppingCartViewController", line: #line, "ERROR: product_quantity or quantityString error.")
                return 0
        }
        return product_quantity
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        unwindToPreviousPage()
    }
    
    // 返回至「」頁
    func unwindToPreviousPage() {
        if from == "ProductPageViewController" {
            self.performSegue(withIdentifier: "unwindToProductPage", sender: self)
        } else if from == "ShoppingCartViewController" {
            self.performSegue(withIdentifier: "unwindToShoppingCart", sender: self)
        }
    }
    
    // TODO: - 隱藏狀態列(StatusBar)
    var darkMode = false
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }

}

// MARK: - Common Methon
extension AddingProductToShoppingCartViewController {
    
    // TODO: - Set Quantity (Zero ~ Unlimited)
    func giveQuantity(label: UILabel, _ quantity: Int) {
        guard let quantity = addOrBack(label: label, quantity: quantity) else {
                PrintHelper.println(tag: "AddingProductToShoppingCartViewController", line: #line, "ERROR: addOrBack() Method is ERROR")
                return
        }
        label.text = String(quantity)
    }
    
    private func addOrBack(label: UILabel, quantity: Int) -> Int? {
        guard let quantityString = label.text, let nowQuantity = Int(quantityString) else {
            PrintHelper.println(tag: "AddingProductToShoppingCartViewController", line: #line, "ERROR: quantityLabel is nil or TypeCasting is Fail ")
            return nil
        }
        let totalQuantity = nowQuantity + quantity
        if totalQuantity <= 1 {
            return 1
        }
        return totalQuantity
    }

}
