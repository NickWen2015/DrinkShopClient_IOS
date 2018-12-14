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
    @IBOutlet weak var productQuantityGroup: UIView!
    
    var productContent: Product? {
        didSet {
            productName.text = String(productContent!.getName())
            productPriceL.text = String(productContent!.getPriceL())
            productPriceM.text = String(productContent!.getPriceM())
        }
    }
    
    var productQuantityContent: Int = 0 {
        didSet {
            if productQuantityContent == 0 {
                productQuantityGroup.isHidden = true
            } else {
                productQuantityGroup.isHidden = false
                productQuantity.text = "\(productQuantityContent)"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // 圓角
        UiHelper.setCornerRadius(view: productImage)
        UiHelper.setCornerRadius(view: productBackground)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
