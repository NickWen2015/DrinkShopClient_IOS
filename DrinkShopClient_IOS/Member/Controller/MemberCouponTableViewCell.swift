//
//  VoucherTableViewCell.swift
//  DSVoucher
//
//  Created by Lucy on 2018/12/5.
//  Copyright © 2018 Lucy. All rights reserved.
//

import UIKit

class MemberCouponTableViewCell: UITableViewCell {

    @IBOutlet weak var starTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
