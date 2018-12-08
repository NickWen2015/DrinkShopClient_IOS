//
//  OrderStatusTableViewCell.swift
//  DSS
//
//  Created by Lucy on 2018/12/4.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class MemberOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderAcceptDateLabel: UILabel!
    
    @IBOutlet weak var orderQuantityLabel: UILabel!
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
