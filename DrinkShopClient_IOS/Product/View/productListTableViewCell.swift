//
//  productListTableViewCell.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/15.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class productListTableViewCell: UITableViewCell {

    @IBOutlet weak var productBackground: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPriceL: UILabel!
    @IBOutlet weak var productPriceM: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    var productList: Product? {
        didSet {
            productName.text = String(productList!.getName())
            productPriceL.text = String(productList!.getPriceL())
            productPriceM.text = String(productList!.getPriceM())
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // 圓角
        setCornerRadius(view: productImage)
        setCornerRadius(view: productBackground)
    }
    
    func setCornerRadius(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
