//
//  ShoppingCartTableViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/6.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class ShoppingCartTableViewController: UITableViewController {
    
    var shoppingCartList: [ShoppingCart]!
    
    static var ShoppingCartVC: ShoppingCartViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingCartViewController.ShoppingCartTableVC = self
    }
    
    private func getShoppingCardList() -> [ShoppingCart] {
        let logSQLite = LogSQLite.init()  // 資料庫
        return logSQLite.searchAllProductInShoppingCart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        ShoppingCartTableViewController.ShoppingCartVC = nil
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingCartList = getShoppingCardList()
        return shoppingCartList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartList", for: indexPath) as! ShoppingCartListTableViewCell
        cell.shoppingCarContent = shoppingCartList[indexPath.row]
        cell.tableView = tableView
        cell.shoppingCartViewController = ShoppingCartTableViewController.ShoppingCartVC
        
        return cell
    }
    
}
