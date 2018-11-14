//
//  ViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/10/7.
//  Copyright © 2018 Nick Wen. All rights reserved.
//  drinkshop ios消費者端

import UIKit

class ProductPageViewController: UIViewController{

    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var borderColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let communicator = Communicator.shared
        communicator.getAllCategory { (result, error) in
            
        }
        
        var categoryCount = 1
        let categoryTitle = ["熱門商品", "超級熱門商品排行榜", "全新上市", "限量推出", "季節限定"]
        let categoryColor = [ColorHelper.red, ColorHelper.orange, ColorHelper.yellow, ColorHelper.green, ColorHelper.blue, ColorHelper.indigo, ColorHelper.purple]
        
        // 產生類別按鈕
        for categoryTitle in categoryTitle {
            let colorIndex = categoryCount % categoryColor.count
            let categoryItem = CategoryItem.init(tag: categoryCount, title: categoryTitle, backgroundColor: categoryColor[colorIndex])
            categoryCount += 1
            categoryView.add(target: self, categoryItem: categoryItem)
        }
    }
    
    // button 的觸發事件
    @objc func buttonAction(_ sender: UIButton) {
        borderColor.backgroundColor = sender.backgroundColor
    }

}

class CY {
    static let BASEURL = Common.SERVER_URL
    static let PRODUCTSERVLET_URL = BASEURL + "ProductServlet"
}

extension Communicator {
    func getAllCategory(completion: @escaping DoneHandler) {
        let parameters: [String: Any] = [ACTION_KEY: "getAllCategory"]
        doPost(urlString: CY.PRODUCTSERVLET_URL, parameters: parameters, completion: completion)
    }
}


