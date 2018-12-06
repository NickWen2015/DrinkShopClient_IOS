//
//  UiHelper.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/12/6.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

final class UiHelper {
    // 圓角
    static func setCornerRadius(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
    
    static func setBackground(view: UIView, color: CGColor) {
        view.layer.backgroundColor = color
    }
    
    static func setBorder(view: UIView, color: CGColor) {
        view.layer.borderWidth = 3
        view.layer.borderColor = color
    }
}
