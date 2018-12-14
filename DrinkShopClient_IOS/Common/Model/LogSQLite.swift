//
//  LogSQLite.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/15.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import Foundation
import SQLite

class LogSQLite {
    
    var db: Connection!
    
    // ShoppingCart 表
    static let TABLENAME_SHOPPINGCART = "DrinkShopClientLogShoppingCart"
    static let SC_ID = "id"
    static let SC_PRODUCT_ID = "product_id"
    static let SC_CATEGORY = "category"
    static let SC_PRODUCT_NAME = "productname"
    static let SC_SIZE = "size"
    static let SC_SIZE_PRICE = "sizePrice"
    static let SC_QUANTITY = "quantity"
    static let SC_SUGAR = "sugar"
    static let SC_TEMPERATURE = "temperature"
    
    var logTable_shoppingCart = Table(TABLENAME_SHOPPINGCART)
    var scIdColumn = Expression<Int>(SC_ID)
    var scProductIdColumn = Expression<Int>(SC_PRODUCT_ID)
    var scCategoryColumn = Expression<String>(SC_CATEGORY)
    var scProductNameColumn = Expression<String>(SC_PRODUCT_NAME)
    var scSizeColumn = Expression<Int>(SC_SIZE)
    var scSizePriceColumn = Expression<Int>(SC_SIZE_PRICE)
    var scQuantityColumn = Expression<Int>(SC_QUANTITY)
    var scSugarColumn = Expression<Int>(SC_SUGAR)
    var scTemperatureColumn = Expression<Int>(SC_TEMPERATURE)
    
    // version 表
    static let TABLENAME_VERSION = "DrinkShopClientLogVersion"
    static let VERSIONS = "versions"
    
    var logTable_version = Table(TABLENAME_VERSION)
    var versionColumn = Expression<Int>(VERSIONS)
    
    // Product 表
    static let TABLENAME_ALLPRODUCT = "DrinkShopClientLogAllProduct"
    static let PRODUCT_ID = "id"
    static let PRODUCT_CATEGORY_ID = "categoryId"
    static let PRODUCT_CATEGORY = "category"
    static let PRODUCT_NAME = "name"
    static let PRODUCT_PROICE_M = "priceM"
    static let PRODUCT_PRICE_L = "priceL"
    
    var logTable_allProduct = Table(TABLENAME_ALLPRODUCT)
    var idColumn = Expression<Int>(PRODUCT_ID)
    var categoryIdColumn = Expression<Int>(PRODUCT_CATEGORY_ID)
    var categoryColumn = Expression<String>(PRODUCT_CATEGORY)
    var nameColumn = Expression<String>(PRODUCT_NAME)
    var priceMColumn = Expression<Int>(PRODUCT_PROICE_M)
    var priceLColumn = Expression<Int>(PRODUCT_PRICE_L)
    var productCount = [String]()
    
    
    //聊天相關資料表
    static let tableName = "messageLog"
    static let midKey = "mid"
    static let idKey = "id"
    static let typeKey = "type"
    static let messageKey = "message"
    static let usernameKey = "username"
    var midColumn = Expression<Int64>(midKey)//對應欄位
    var idChatColumn = Expression<Int64>(idKey)//對應欄位
    var typeColumn = Expression<Int64>(typeKey)//對應欄位
    var messageColumn = Expression<String>(messageKey)//對應欄位
    var usernameColumn = Expression<String>(usernameKey)//對應欄位
    var logMessageTable = Table(tableName)//聊天資料表
    
    init() {
        // Prepare DB filename/path.
        let filemanager = FileManager.default
        guard let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fullURLPath = documentsURL.appendingPathComponent("log.sqlite").path
        var isNewDB = false
        if !filemanager.fileExists(atPath: fullURLPath) {
            isNewDB = true
        }
        
        // Prepare connection of DB.
        do {
            db = try Connection(fullURLPath)
        } catch {
            assertionFailure("Fail to create connection.")
            return
        }
        
        // Create Table at the first time.
        if isNewDB {
            do {
                let command_version = logTable_version.create { (builder) in
                    builder.column(versionColumn)
                }
                
                let command_allProduct = logTable_allProduct.create { (builder) in
                    builder.column(idColumn)
                    builder.column(categoryIdColumn)
                    builder.column(categoryColumn)
                    builder.column(nameColumn)
                    builder.column(priceMColumn)
                    builder.column(priceLColumn)
                }
                
                let command_shoppingCart = logTable_shoppingCart.create { (builder) in
                    builder.column(scIdColumn, primaryKey: .autoincrement)
                    builder.column(scProductIdColumn)
                    builder.column(scCategoryColumn)
                    builder.column(scProductNameColumn)
                    builder.column(scSizeColumn)
                    builder.column(scSizePriceColumn)
                    builder.column(scQuantityColumn)
                    builder.column(scSugarColumn)
                    builder.column(scTemperatureColumn)
                }
                
                //聊天資料表
                let command_logMessage = logMessageTable.create { (builder) in
                    builder.column(midColumn, primaryKey: true)//PK
                    builder.column(idChatColumn)//依序建立
                    builder.column(messageColumn)//依序建立
                    builder.column(typeColumn)//依序建立
                    builder.column(usernameColumn)//依序建立
                }
                
                try db.run(command_version)
                try db.run(command_allProduct)
                try db.run(command_shoppingCart)
                try db.run(command_logMessage)
                PrintHelper.println(tag: "LogSQLite", line: #line, "DB CREATE OK!")
                
                // 加入初始值
                append(version: 0, to: "append")
                
            } catch {
                assertionFailure("Fail to create table: \(error).")
            }
        } else {
            // Keep mid into messageIDs.
            do {
                // SELECT * FROM "DrinkShopClientLogAllProduct"
                for product in try db.prepare(logTable_allProduct) {
                    productCount.append(product[nameColumn])
                }
            } catch {
                assertionFailure("Fail to execute prepare command: \(error).")
            }
            print("There are total \(productCount.count) Product in DB")
        }
    }

}

// MARK: - ShoppingCart
extension LogSQLite {
    
    func getShoppingCartCount() -> Int {
        var count = 0
        do {
            for _ in try db.prepare(logTable_shoppingCart) {
                count += 1
            }
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Search All Product In ShoppingCart")
            assertionFailure("\(#line) Fail to searchAllProductInShoppingCart: \(error)")
        }
        return count
    }
    
    // 新增購買的商品
    func appendSelectProduct(_ shoppingCart: ShoppingCart) {
        let productId = shoppingCart.getProductId()
        let category = shoppingCart.getCategory()
        let productName = shoppingCart.getProductName()
        let size = shoppingCart.getSize()
        let sizePrice = shoppingCart.getSizePrice()
        let quantity = shoppingCart.getQuantity()
        let sugar = shoppingCart.getSugar()
        let temperature = shoppingCart.getTemperature()
        
        let command = logTable_shoppingCart.insert(
            scProductIdColumn <- productId,
            scCategoryColumn <- category,
            scProductNameColumn <- productName,
            scSizeColumn <- size,
            scSizePriceColumn <- sizePrice,
            scQuantityColumn <- quantity,
            scSugarColumn <- sugar,
            scTemperatureColumn <- temperature
        )
        do {
            try db.run(command)
            
            for shoppingCart in searchAllProductInShoppingCart() {
                print("\(shoppingCart.getId())")
            }
            
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "Fail to insert a shoppingCart: \(error).")
            assertionFailure("Fail to insert a shoppingCart: \(error).")
        }
    }
    
    // 修改購買的商品
    func updateSelectProduct(id: Int, sc: ShoppingCart) {
        let cond = logTable_shoppingCart.filter(scIdColumn == id)
        
        let command = cond.update(
            scProductIdColumn <- sc.getProductId(),
            scCategoryColumn <- sc.getCategory(),
            scProductNameColumn <- sc.getProductName(),
            scSizeColumn <- sc.getSize(),
            scSizePriceColumn <- sc.getSizePrice(),
            scQuantityColumn <- sc.getQuantity(),
            scSugarColumn <- sc.getSugar(),
            scTemperatureColumn <- sc.getTemperature()
        )
        do {
            try db.run(command)
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Update Select Product")
            assertionFailure("\(#line) Fail to updateSelectProduct: \(error)")
        }
    }
    
    
    // 刪除購買的商品
    func deleteSelectProduct(id: Int) {
        let cond = logTable_shoppingCart.filter(scIdColumn == id)
        let command = cond.delete()
        do {
            try db.run(command)
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Delete Select Product")
            assertionFailure("\(#line) Fail to deleteSelectProduct: \(error)")
        }
    }
    
    // 顯示所有購買的商品
    func searchAllProductInShoppingCart() -> [ShoppingCart] {
        var result = [ShoppingCart]()
        do {
            for shoppingCart in try db.prepare(logTable_shoppingCart) {
                result.append(getRecord(shoppingCart, from: #function))
            }
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Search All Product In ShoppingCart")
            assertionFailure("\(#line) Fail to searchAllProductInShoppingCart: \(error)")
        }
        
        return result
    }
    
    // 顯示購買商品數量
    func searchProductQuantityInShoppingCart(productName: String) -> Int {
        var result: Int = 0
        let command = logTable_shoppingCart.select(scQuantityColumn)
                                        .filter(scProductNameColumn == productName)
        do {
            for shoppingCart in try db.prepare(command) {
                var sc = ShoppingCart()
                sc.quantity = shoppingCart[scQuantityColumn]
                
                PrintHelper.println(tag: "LogSQLite", line: #line, "\(productName) : \(sc)杯")
                result += sc.getQuantity()
            }
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Search Product Quantity In ShoppingCart")
            assertionFailure("\(#line) Fail to searchProductQuantityInShoppingCart: \(error)")
        }
        return result
    }
    
    // 顯示選取商品的資訊
    func searchProductDetail(id: Int) -> [ShoppingCart] {
        var result = [ShoppingCart]()
        let cond = logTable_shoppingCart.filter(scIdColumn == id)
        do {
            for shoppingCart in try db.prepare(cond) {
                result.append(getRecord(shoppingCart, from: #function))
            }
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Search Product Detail")
            assertionFailure("\(#line) Fail to searchProductQuantityInShoppingCart: \(error)")
        }
        return result
    }
    
    // 取的總杯數及總金額
    func searchTotalCapAndTotalAmount() -> [ShoppingCartTotol] {
        var result = [ShoppingCartTotol]()
        let command = logTable_shoppingCart.select([scSizePriceColumn, scQuantityColumn])
        do {
            for shppingCart in try db.prepare(command) {
                var sct = ShoppingCartTotol()
                sct.price = shppingCart[scSizePriceColumn]
                sct.quantity = shppingCart[scQuantityColumn]
                PrintHelper.println(tag: "LogSQLite", line: #line, "Method: \(#function)" + "\n" +
                    "價格: \(String(describing: sct.getPrice())), 數量: \(String(describing: sct.getQuantity()))")
                result.append(sct)
            }
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: Search TotalCap And TotalAmount")
            assertionFailure("\(#line) Fail to searchTotalCapAndTotalAmount: \(error)")
        }
        return result
    }
    
    // 把目前的資料包裝為物件
    func getRecord(_ shoppingCart: Row, from method: String) -> ShoppingCart {
        var result = ShoppingCart()
        result.id = shoppingCart[scIdColumn]
        result.productId = shoppingCart[scProductIdColumn]
        result.category = shoppingCart[scCategoryColumn]
        result.productName = shoppingCart[scProductNameColumn]
        result.size = shoppingCart[scSizeColumn]
        result.sizePrice = shoppingCart[scSizePriceColumn]
        result.quantity = shoppingCart[scQuantityColumn]
        result.sugar = shoppingCart[scSugarColumn]
        result.temperature = shoppingCart[scTemperatureColumn]
        
        PrintHelper.println(tag: "LogSQLite", line: #line,
                            "Method: \(method)" + "\n" +
                                "ID: \(String(describing: result.getId()))" + "\n" +
                                "商品ID: \(String(describing: result.getProductId()))" + "\n" +
                                "類別: \(String(describing: result.getCategory()))" + "\n" +
                                "品名: \(String(describing: result.getProductName()))" + "\n" +
                                "大小: \(String(describing: result.getSize()))" + "\n" +
                                "單價: \(String(describing: result.getSizePrice()))" + "\n" +
                                "數量: \(String(describing: result.getQuantity()))" + "\n" +
                                "甜度: \(String(describing: result.getSugar()))" + "\n" +
                                "溫度: \(String(describing: result.getTemperature()))" + "\n"
        )
        
        return result
    }
}

// MARK: - Product Func
extension LogSQLite {
    
    // 資料總比數
    var count: Int {
        return productCount.count
    }

    
    // 新增 Product
    func appendNewProduct(_ product: Product) {
        
        let id = product.getId()
        let categoryId = product.getCategoryId()
        let category = product.getCategory()
        let name = product.getName()
        let priceM = product.getPriceM()
        let priceL = product.getPriceL()
        
        let command = logTable_allProduct.insert(
            idColumn <- id,
            categoryIdColumn <- categoryId,
            categoryColumn <- category,
            nameColumn <- name,
            priceMColumn <- priceM,
            priceLColumn <- priceL
        )
        do {
            try db.run(command)
        } catch {
            PrintHelper.println(tag: "LogSQLite", line: #line, "ERROR: insert a new product")
            assertionFailure("\(#line) Fail to insert a new product: \(error).")
        }
    }
    
    // 使用 id 搜尋 商品價錢
    func searchProductPriceInId(_ id: Int) -> Product {
        var result = Product()
        let cond = logTable_allProduct.filter(idColumn == id)
        
        do {
            // SELECT * FROM "DrinkShopClientLog WHERE id = id"
            for product in try db.prepare(cond) {
                let priceM = product[priceMColumn]
                let priceL = product[priceLColumn]
                
                result.priceM = priceM
                result.priceL = priceL
            }
        } catch {
            assertionFailure("Fail to execute prepare command: \(error).")
        }
        
        return result
    }
    
    // 使用 類別 搜尋 商品
    func searchProductInCategory(to category: String) -> [Product] {
        var productArray: [Product] = []
        
        let cond = logTable_allProduct.filter(categoryColumn == category)
        
        do {
            // SELECT * FROM "DrinkShopClientLog WHERE category = category"
            for product in try db.prepare(cond) {
                let id = product[idColumn]
                let categoryId = product[categoryIdColumn]
                let category = product[categoryColumn]
                let name = product[nameColumn]
                let priceM = product[priceMColumn]
                let priceL = product[priceLColumn]
                
                var productObj = Product()
                productObj.id = id
                productObj.categoryId = categoryId
                productObj.category = category
                productObj.name = name
                productObj.priceM = priceM
                productObj.priceL = priceL
                
                productArray.append(productObj)
            }
        } catch {
            assertionFailure("Fail to execute prepare command: \(error).")
        }
        
        return productArray
    }
}

// MARK: - Version Func
extension LogSQLite {
    // 新增 version
    func append(version: Int, to: String) {
        let command = logTable_version.insert(versionColumn <- version)
        do {
            try db.run(command)
            if to == "append" {
                PrintHelper.println(tag: "LogSQLite", line: #line, "append version OK")
            }
        } catch {
            assertionFailure("\(#line) Fail to insert a new version: \(error).")
        }
    }
    
    // 更新 version
    func updateVersion(version: Int) {
        delete(table: logTable_version)
        append(version: version, to: "updateVersion")
        PrintHelper.println(tag: "LogSQLite", line: #line, "update version OK")
    }
    
    // 獲得最目前版本
    func searchCurrentVersion() -> Int? {
        var currentVersion = 0
        do {
            for version in try db.prepare(logTable_version) {
                currentVersion = version[versionColumn]
            }
            return currentVersion
        } catch {
            assertionFailure("Fail to execute prepare command: \(error).")
        }
        PrintHelper.println(tag: "LogSQLite", line: #line, "search version OK")
        return nil
    }
}

// MARK: - Common Func
extension LogSQLite {
    // 刪除
    func delete(table: Table) {
        do {
            try db.run(table.delete())
        } catch {
            assertionFailure("\(#line) Fail to delete: \(error).")
        }
        PrintHelper.println(tag: "LogSQLite", line: #line, "PASSED: \(#function) \(table) OK")
    }
}
