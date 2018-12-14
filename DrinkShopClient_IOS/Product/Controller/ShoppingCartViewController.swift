//
//  ShoppingCartViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/4.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

extension ShoppingCartViewController : ProductCouponToShoppingCart {
    func fetchData(coupon: Coupon) {
        PrintHelper.println(tag: "ShoppingCartVC", line: #line, "coupon: \(coupon)")
        self.coupon = coupon
    }
}

class ShoppingCartViewController: UIViewController {
    
    @IBOutlet weak var shoppingCartListView: UIView!
    @IBOutlet weak var shoppingCartNoProductView: UIView!
    
    @IBOutlet weak var takeOutButton: UIButton!
    @IBOutlet weak var orderInButton: UIButton!
    @IBOutlet weak var useCouponButton: UIButton!
    @IBOutlet weak var totalCapLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    let logSQLite = LogSQLite.init()  // 資料庫
    
    let communicator = Communicator.shared
    
    private var order_type = "0" // 訂單類型預設為 自取
    
    var coupon = Coupon()
    
    var shoppingCarContent: ShoppingCart!
    static var ShoppingCartTableVC: ShoppingCartTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProductCouponTableViewController.shoppingCartVC = self
        ShoppingCartTableViewController.ShoppingCartVC = self
        setTotalCapAndTotalAmount()
        setShoppingCartListHiddenStatus()
        
        UiHelper.setCornerRadius(view: takeOutButton)
        UiHelper.setCornerRadius(view: orderInButton)
        UiHelper.setBorder(view: takeOutButton, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        UiHelper.setBorder(view: orderInButton, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if coupon.coupon_id != 0 {
            let couponButtonText = "\(Int(coupon.coupon_discount))折"
            useCouponButton.setTitle(couponButtonText, for: .normal)
        }
        ShoppingCartViewController.ShoppingCartTableVC.tableView.reloadData()
    }
    
    // 設定 shoppingCartListView 的隱藏狀態
    // 購物車商品數 == 0 就 顯示 shoppingCartNoProductView
    // 購物車商品數 != 0 就 顯示 shoppingCartListView
    func setShoppingCartListHiddenStatus() {
        let count = logSQLite.getShoppingCartCount()
        if count == 0 {
            shoppingCartListView.isHidden = true
            shoppingCartNoProductView.isHidden = false
        } else {
            shoppingCartListView.isHidden = false
            shoppingCartNoProductView.isHidden = true
        }
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
    
    // 準備訂單清單
    private func prepareOrder(_ member_id: Int) -> Order {
        let storeId = 1
        
        var order = Order()
        order.store_id = storeId
        order.member_id = member_id
        order.order_type = order_type
        order.coupon_id = coupon.coupon_id
        
        return order
    }
    
    // 準備商品清單
    private func prepareShoppingCartList() -> [OrderDetail] {
        var orderDetailList = [OrderDetail]()
        let allProduct = logSQLite.searchAllProductInShoppingCart()
        for product in allProduct {
            var orderDetail = OrderDetail()
            orderDetail.product_id = product.getProductId()
            orderDetail.size_id = product.getSize()
            orderDetail.sugar_id = product.getSugar()
            orderDetail.ice_id = product.getTemperature()
            orderDetail.product_quantity = product.getQuantity()
            orderDetailList.append(orderDetail)
        }
        return orderDetailList
    }
    // 按下選擇優惠卷
    @IBAction func selectCouponButton(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "isLogin") as? Bool == true {
            PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "已登入")
            self.performSegue(withIdentifier: "shoppingCartGoSelectCoupon", sender: nil)
        } else {
            PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "未登入")
            let login = Login(view: self, from: "ShoppingCart")
            login.login()
        }
    }
    
    
    
    // 按下完成觸發
    @IBAction func orderCompletedButton(_ sender: Any) {
        let alertController = UIAlertController(title: "訂單確認", message:
            "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: { (action) in
            self.login()
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func login() {
        let login = Login(view: self, from: "ShoppingCart")
        
        if UserDefaults.standard.value(forKey: "isLogin") as? Bool == true {
            
            if prepareShoppingCartList().isEmpty {
                return
            }
            
            guard let member_id = UserDefaults.standard.value(forKey: "member_id") as? Int else {
                assertionFailure("ERROR: member_id is nil")
                return
            }
            PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "已登入")
            
            let order = prepareOrder(member_id)
            let orderDetails = prepareShoppingCartList()
            
            communicator.orderInsert(order: order, orderDetails: orderDetails) { (result, error) in
                if let error = error {
                    PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "ERROR: \(error)")
                    return
                }
                
                guard let result = result else {
                    PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "ERROR: result is nil")
                    return
                }
                
                PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "PASSED: result OK.")
                
                guard let returnResult = result as? String else {
                    PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "ERROR: returnResult is nil")
                    return
                }
                
                if returnResult == "0" {
                    PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "建立訂單失敗！")
                } else {
                    PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "建立訂單成功！")
                    self.logSQLite.delete(table: self.logSQLite.logTable_shoppingCart)
                    if self.coupon.coupon_id != 0 {
                        
                        let encoder = JSONEncoder()
                        guard let couponData = try? encoder.encode(self.coupon) else {
                            assertionFailure("Cast coupon to json is Fail.")
                            return
                        }
                        
                        guard let couponString = String(data: couponData, encoding: .utf8) else {
                            assertionFailure("Cast orderString to String is Fail.")
                            return
                        }
                        self.communicator.couponUpdateStatus(coupon: couponString, completion: { (result, error) in
                            if let error = error {
                                PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "ERROR: \(error)")
                                return
                            }
                            
                            guard let result = result else {
                                PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "ERROR: result is nil")
                                return
                            }
                            
                            PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "PASSED: result OK.")
                            
                            if let count = result as? String {
                                if count == "0" {
                                    PrintHelper.println(tag: "ShoppingCartVC", line: #line, "ERROR: coupon updata Failure")
                                } else {
                                    PrintHelper.println(tag: "ShoppingCartVC", line: #line, "PASSED: coupon updata Success")
                                }
                            }
                        })
                    }
                    self.performSegue(withIdentifier: "unwindToMemberFunction", sender: self)
                    
                }
                
            }
            
        } else {
            PrintHelper.println(tag: "ShoppingCartViewController", line: #line, "未登入")
            login.login()
            
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
        setShoppingCartListHiddenStatus()
    }
}

// MARK: - Common Method
extension ShoppingCartViewController {
    
    // 設定總金額及總杯數
    func setTotalCapAndTotalAmount() {
        var totalCap = 0
        var totalAmount = 0.0
        let shoppingCartTotals = logSQLite.searchTotalCapAndTotalAmount()
        for shoppingCartTotal in shoppingCartTotals {
            let quantity = shoppingCartTotal.getQuantity()
            let price = shoppingCartTotal.getPrice()
            
            totalCap += quantity
            totalAmount += Double(quantity * price)
        }
        totalAmount *= coupon.coupon_discount * 0.1
        totalCapLabel.text = "\(totalCap) 杯"
        totalAmountLabel.text = "\(Int(totalAmount)) 元"
        
    }
}

extension Communicator {
    
    func orderInsert(order: Order, orderDetails: [OrderDetail], completion: @escaping DoneHandler) {
        let encoder = JSONEncoder()
        
        guard let orderData = try? encoder.encode(order) else {
            assertionFailure("Cast order to json is Fail.")
            return
        }
            
        guard let orderString = String(data: orderData, encoding: .utf8) else {
            assertionFailure("Cast orderString to String is Fail.")
            return
        }

        guard let orderDetailsData = try? encoder.encode(orderDetails) else {
            assertionFailure("Cast orderDetailsData to json is Fail.")
            return
        }
        
        guard let orderDetailsString = String(data: orderDetailsData, encoding: .utf8) else {
            assertionFailure("Cast orderDetailsString to String is Fail.")
            return
        }
        
        let urlString = Communicator.shared.ORDERSERVLET_URL
        let parameters: [String: Any] = [ACTION_KEY: "orderInsert", "order": orderString, "orderDetailList": orderDetailsString]
        doPost(urlString: urlString, parameters: parameters, completion: completion)
        
    }
}
