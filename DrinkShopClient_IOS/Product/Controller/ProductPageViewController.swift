//
//  ViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/10/7.
//  Copyright © 2018 Nick Wen. All rights reserved.
//  drinkshop ios消費者端

import UIKit

extension ProductPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productListCell", for: indexPath) as! productListTableViewCell
        cell.selectionStyle = .none  // 取消選取狀態
        let product = productArray[indexPath.row]
        cell.productContent = product
        cell.productQuantityContent = logSQLite.searchProductQuantityInShoppingCart(productName: product.getName())
        
        // TODO: - 設定 image
        let id = product.getId()
        if let image = imageDic[id] {
            cell.productImage.image = image
        } else {
            cell.productImage.image = nil
            
            Communicator.shared.getPhotoById(photoURL: communicator.PRODUCT_PHOTO_URL, id: id) { (result, error) in
                guard let data = result else {
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageDic[id] = image
                        cell.productImage.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    // 自動改變高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ProductPageViewController: UIViewController {

    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var borderColorView: UIView!
    @IBOutlet weak var productListTableView: UITableView!
    
    var version: Int? = nil
    var imageDic = [Int: UIImage]()
    
    let communicator = Communicator.shared  // 傳送資料用
    
    var categoryArray: [Category] = []  // 類別陣列
    var productArray: [Product] = []  // 選擇的類別的商品陣列
    
    let categoryColor = [ColorHelper.red, ColorHelper.purple, ColorHelper.yellow, ColorHelper.green, ColorHelper.blue, ColorHelper.indigo, ColorHelper.orange]
    
    var tableView: UITableView!
    
    let logSQLite = LogSQLite.init()  // 資料庫
    
    var completionRate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 顯示全部的類別
        self.showAllCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productListTableView.reloadData()
        
        guard let version = logSQLite.searchCurrentVersion() else {
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: search current version is nil ")
            return
        }
        // SQLite 版本編號
        versionSynchronization(lastVersion: version)
    }
    
    // button 的觸發事件x
    @objc func buttonAction(_ sender: UIButton) {
        borderColorView.backgroundColor = sender.backgroundColor
        guard let category = sender.titleLabel?.text else {
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: category is nil or category count is 0")
            return
        }
        PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: category: \(category)")
        productArray = logSQLite.searchProductInCategory(to: category)
        PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: productArray: \(productArray)")
        
        guard let version = logSQLite.searchCurrentVersion() else {
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: search current version is nil ")
            return
        }
        // SQLite 版本編號
        versionSynchronization(lastVersion: version)
        
        productListTableView.reloadData()
    }
    
    // 將選擇的商品明細傳送至AddingProduct頁面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productPageGoAddingProduct" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let product = productArray[selectedIndexPath.row]
                let addingProduct = segue.destination as! AddingProductToShoppingCartViewController
                addingProduct.product_id = product.getId()
                addingProduct.category = product.getCategory()
                addingProduct.productName = product.getName()
                addingProduct.priceM = product.getPriceM()
                addingProduct.priceL = product.getPriceL()
                addingProduct.size = 1
                addingProduct.sugar = 1
                addingProduct.temperature = 1
                addingProduct.from = "ProductPageViewController"
                addingProduct.quantity = 1
            }
        }
    }
    
    @IBAction func unwindToProductPageViewController(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
        tableView.reloadData()
    }
    
    // 設置初始畫面
    func setTheInitialScreen() {
        if completionRate >= 2 {
            borderColorView.backgroundColor = categoryColor[0]
            guard let firstCategory = categoryArray.first?.name else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: category is nil or category name is nil")
                return
            }
            productArray = logSQLite.searchProductInCategory(to: firstCategory)
            productListTableView.reloadData()
        }
        PrintHelper.println(tag: "ProductPageViewController", line: #line, "completionRate: \(completionRate)")
    }
    
    deinit {
        PrintHelper.println(tag: "ProductPageViewController", line: #line, "deinit")
    }

}

extension ProductPageViewController {
    
    // 顯示全部的類別
    func showAllCategory() {
        communicator.getAllCategory { (result, error) in
            if let error = error {

                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: \(error)")
                return
            }
            
            guard let result = result else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: result is nil")
                return
            }
            
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: result OK.")

            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("\(#line) Fail to generate jsonData.")
                return
            }
            
            let decoder = JSONDecoder()
            guard let categoryObject = try? decoder.decode([Category].self, from: jsonData) else {
                print("\(#line) Fail to decode jsonData.")
                return
            }
            
            self.categoryArray = categoryObject

            PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: \(#function) OK.")

            // 清除所有的 categoryView
            self.categoryView.deleteOld()

            // 將資料與UI相連
            self.linkCategoryUI()
            
            // 設置初始畫面
            self.completionRate += 1
            if !(self.completionRate >= 3) {
                self.setTheInitialScreen()
            }
        }
    }
    
    // 將Category資料與UI相連
    func linkCategoryUI() {
        var categoryCount = 0
        
        
        // 產生類別按鈕
        for category in categoryArray {
            let colorIndex = categoryCount % (categoryColor.count - 1)
            guard let tag = category.id, let title = category.name else {
                continue
            }
            
            let categoryItem = CategoryItem.init(tag: tag, title: title, backgroundColor: categoryColor[colorIndex])
            categoryCount += 1
            categoryView.add(target: self, categoryItem: categoryItem)
        }
    }
}

extension ProductPageViewController {
    // 版本同步
    func versionSynchronization(lastVersion: Int) {
        communicator.getProductsVersions(version: lastVersion) { (result, error) in
            if let error = error {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: \(error)")
                return
            }
            
            guard let result = result else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: result is nil")
                return
            }
            
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: result OK.")
            
            guard let nowVersion = result as? Int else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: nowVersion is nil")
                return
            }

            // 版本是否同步
            let isNotSynchronization = (nowVersion != lastVersion)
            if isNotSynchronization {
                // 顯示全部的類別
                self.showAllCategory()
                
                // 準備全部商品資料 存 SQLite
                self.getAllProductSaveSQLite()
                self.version = nowVersion
            } else {
                // 設置初始畫面
                self.completionRate += 1
                if !(self.completionRate >= 3) {
                    self.setTheInitialScreen()
                }
            }
            
        }
    }
}

extension ProductPageViewController {
    // 準備全部商品資料 存 SQLite 儲存前把舊資料清空 並把類別顯示出來
    func getAllProductSaveSQLite() {
        
        communicator.getAllProduct { (result, error) in
            if let error = error {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: \(error)")
                return
            }
            
            guard let result = result else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: result is nil")
                return
            }
            
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "result OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: Fail to generate jsonData.")
                return
            }
            
            let decoder = JSONDecoder()
            guard let productObject = try? decoder.decode([Product].self, from: jsonData) else {
                PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: Fail to decode jsonData.")
                return
            }
            
            self.productArray = productObject
            
            // CLAER TABLE DrinkShopClientLogAllProduct
            self.logSQLite.delete(table: self.logSQLite.logTable_allProduct)
            
            for product in self.productArray {
                self.logSQLite.appendNewProduct(product)
            }
            
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: \(#function) OK")
            
            self.versionSave()
            
            // 設置初始畫面
            self.completionRate += 1
            self.setTheInitialScreen()
        }
    }
    
}

extension ProductPageViewController {
    // 版本改變時儲存
    func versionSave() {
        // 如果版本沒有改變 version 就是 nil，版本改變後 version 等於 nowVersion.
        guard let version = version else {
            PrintHelper.println(tag: "ProductPageViewController", line: #line, "ERROR: version is not change")
            return
        }
        // SQLite 版本編號 Save
        logSQLite.updateVersion(version: version)
        
        PrintHelper.println(tag: "ProductPageViewController", line: #line, "PASSED: \(#function) OK")
    }
}

extension Communicator {
    
    // 取得本機持有版本
    func getProductsVersions(version: Int, completion: @escaping DoneHandler) {
        let urlString = Communicator.shared.PRODUCTSERVLET_URL
        let parameters: [String: Any] = [ACTION_KEY: "getProductsVersions", "lastVersion": version]
        doPost(urlString: urlString, parameters: parameters, completion: completion)
    }
    
    // 取得全部的類別
    func getAllCategory(completion: @escaping DoneHandler) {
        let urlString = Communicator.shared.PRODUCTSERVLET_URL
        let parameters: [String: Any] = [ACTION_KEY: "getAllCategory"]
        doPost(urlString: urlString, parameters: parameters, completion: completion)
    }
    
    // 取得全部的商品
    func getAllProduct(completion: @escaping DoneHandler) {
        let urlString = Communicator.shared.PRODUCTSERVLET_URL
        let parameters: [String: Any] = [ACTION_KEY: "getAllProduct"]
        doPost(urlString: urlString, parameters: parameters, completion: completion)
    }
}

