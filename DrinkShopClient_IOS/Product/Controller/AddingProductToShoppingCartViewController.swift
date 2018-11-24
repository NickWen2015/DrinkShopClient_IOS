//
//  AddingProductToShoppingCartViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/20.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class AddingProductToShoppingCartViewController: UIViewController {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var backQuantityButton: UIButton!
    @IBOutlet weak var addQuantityButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    // TODO: - 隱藏狀態列(StatusBar)
    var darkMode = false
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }

}

// MARK: - Common Methon
extension AddingProductToShoppingCartViewController {
    func addOrBack(quantity: Int) -> Int? {
        guard let quantityString = quantityLabel.text, let nowQuantity = Int(quantityString) else {
            PrintHelper.println(tag: "AddingProductToShoppingCartViewController", line: #line, "ERROR: quantityLabel is nil or TypeCasting is Fail ")
            return nil
        }
        let totalQuantity = nowQuantity + quantity
        if totalQuantity == 0 {
            return 0
        }
        return totalQuantity
    }
}
