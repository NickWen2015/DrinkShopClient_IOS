//
//  ViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/10/7.
//  Copyright © 2018 Nick Wen. All rights reserved.
//  drinkshop ios消費者端

import UIKit

let TAG = "ProductPageViewController"

class ProductPageViewController: UIViewController {
    
    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var borderColor: UIView!
    
    let communicator = Communicator.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllCategory()

        var categoryTag = 1
        let categoryTitle = ["熱門商品", "超級熱門商品排行榜", "全新上市", "限量推出", "季節限定"]
        let categoryColor = [ColorHelper.red, ColorHelper.orange, ColorHelper.yellow, ColorHelper.green, ColorHelper.blue, ColorHelper.indigo, ColorHelper.purple]
        
        // 產生類別按鈕
        for categoryTitle in categoryTitle {
            let colorIndex = categoryTag % categoryColor.count
            let categoryItem = CategoryItem.init(tag: categoryTag, title: categoryTitle, backgroundColor: categoryColor[colorIndex])
            categoryTag += 1
            categoryView.add(target: self, categoryItem: categoryItem)
        }
    }
    
    // button 的觸發事件
    @objc func buttonAction(_ sender: UIButton) {
        borderColor.backgroundColor = sender.backgroundColor
    }

}

extension ProductPageViewController {
    
    // 顯示全部的類別
    func showAllCategory() {
        communicator.getAllCategory { (result, error) in
            if let error = error {
                printHelper.println(tag: TAG, line: #line, "Error: \(error)")
                return
            }
            
            guard let result = result else {
                printHelper.println(tag: TAG, line: #line, "result is nil")
                return
            }
            
            printHelper.println(tag: TAG, line: #line, "result OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("\(#line) Fail to generate jsonData.")
                return
            }
            
            let decoder = JSONDecoder()
            guard let categoryObject = try? decoder.decode([Category].self, from: jsonData) else {
                print("\(#line) Fail to decode jsonData.")
                return
            }
            for c in categoryObject {
                printHelper.println(tag: TAG, line: #line, "categoryObject: \(c)")
            }
            
        }
    }
}


extension Communicator {
    
    // 取得全部的類別
    func getAllCategory(completion: @escaping DoneHandler) {
        let urlString = Communicator.shared.PRODUCTSERVLET_URL
        let parameters: [String: Any] = [ACTION_KEY: "getAllCategory"]
        doPost(urlString: urlString, parameters: parameters, completion: completion)
    }
}


