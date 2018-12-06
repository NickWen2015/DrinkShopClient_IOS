//
//  AddingProductToShoppingCartTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/20.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit
extension AddingProductToShoppingCartTableViewController:  AddingProductToShoppingCartTableFetchDataDelegate{
    // 將初始值傳過來
    func fetchData(size: Int, sugar: Int, temperature: Int) {
        self.size = size - 1
        self.sugar = sugar - 1
        self.temperature = temperature - 1
        // 設置初始畫面
        selected(pickItems: sizePickItemImage, self.size)
        selected(pickItems: sugarPickItemImage, self.sugar)
        selected(pickItems: temperaturePickItemImage, self.temperature)
    }
}

class AddingProductToShoppingCartTableViewController: UITableViewController {
    
    @IBOutlet var sizePickItemImage: [UIImageView]!
    @IBOutlet var sugarPickItemImage: [UIImageView]!
    @IBOutlet var temperaturePickItemImage: [UIImageView]!

    private let SELECT_SIZE = 0
    private let SELECT_SUGAR = 1
    private let SELECT_TEMPERATURE = 2
    
    static var AddingProductVC: AddingProductToShoppingCartViewController!

    var size = 0
    var sugar = 0
    var temperature = 0
    
    var delegate: AddingProductToShoppingCartFetchDataDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddingProductToShoppingCartViewController.AddingProductTableVC = self
    }

    // tableView select Method.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSection(indexPath)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        AddingProductToShoppingCartTableViewController.AddingProductVC = nil
    }
    
    // User Select Section
    private func selectSection(_ indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case SELECT_SIZE:
            size(row: indexPath.row)
            break
        case SELECT_SUGAR:
            sugar(row: indexPath.row)
            break
        case SELECT_TEMPERATURE:
            temperature(row: indexPath.row)
            break
        default:
            break
        }
    }
    
    // User Select Size
    private func size(row selectItem: Int) {
        size = selectItem
        selected(pickItems: sizePickItemImage, selectItem)
    }
    
    // User Select Sugar
    private func sugar(row selectItem: Int) {
        sugar = selectItem
        selected(pickItems: sugarPickItemImage, selectItem)
    }
    
    // User Select Temperature
    private func temperature(row selectItem: Int) {
        temperature = selectItem
        selected(pickItems: temperaturePickItemImage, selectItem)
    }
    
    // User Select Item
    private func selected(pickItems: [UIImageView] ,_ selectItem: Int) {
        for pickItem in pickItems {
            if pickItem.tag == pickItems[selectItem].tag {
                pickItem.image = UIImage(named: "img_product_select.png")
                continue
            }
            pickItem.image = UIImage(named: "img_product_non_select.png")
        }
        
        // return the result to AddingProductVC.
        self.delegate = AddingProductToShoppingCartTableViewController.AddingProductVC
        self.delegate?.fetchData(size: size, sugar: sugar, temperature: temperature)
    }
    
    
    
}
