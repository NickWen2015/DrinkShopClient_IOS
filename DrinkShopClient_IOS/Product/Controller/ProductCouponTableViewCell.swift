//
//  ProductCouponTableViewCell.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/10.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

class ProductCouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
