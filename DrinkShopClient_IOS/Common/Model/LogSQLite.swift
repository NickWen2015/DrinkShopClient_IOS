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
    
    // version 表
    static let tableName_version = "DrinkShopClientLogVersion"
    static let versions = "versions"
    
    var logTable_version = Table(tableName_version)
    var versionColumn = Expression<Int>(versions)
    
    // Product 表
    static let tableName_allProduct = "DrinkShopClientLogAllProduct"
    static let id = "id"
    static let categoryId = "categoryId"
    static let category = "category"
    static let name = "name"
    static let priceM = "priceM"
    static let priceL = "priceL"
    
    var logTable_allProduct = Table(tableName_allProduct)
    var idColumn = Expression<Int>(id)
    var categoryIdColumn = Expression<Int>(categoryId)
    var categoryColumn = Expression<String>(category)
    var nameColumn = Expression<String>(name)
    var priceMColumn = Expression<Int>(priceM)
    var priceLColumn = Expression<Int>(priceL)
    
    var productCount = [String]()
    
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
                try db.run(command_version)
                try db.run(command_allProduct)
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
            print("There are total \(productCount.count) messages in DB")
        }
    }

}

// MARK: - Product Func
extension LogSQLite {
    
    // 資料總比數
    var count: Int {
        return productCount.count
    }
    
    // 新增 Product
    func append(_ product: Product) {
        
//        guard let id = product.id,
//            let categoryId = product.categoryId,
//            let category = product.category,
//            let name = product.name,
//            let priceM = product.priceM,
//            let priceL = product.priceL else {
//                PrintHelper.println(tag: "LogSQLite", line: #line, "SQLite append Error.")
//                return
//        }
        
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
            assertionFailure("\(#line) Fail to insert a new product: \(error).")
        }
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
                
//                let productObj = Product.init(id: id, categoryId: categoryId, category: category, name: name, priceM: priceM, priceL: priceL)
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
