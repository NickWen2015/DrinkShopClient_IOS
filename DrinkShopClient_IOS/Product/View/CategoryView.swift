//
//  Page.swift
//  DrinkShopClient_IOS
//
//  Created by Mrosstro on 2018/11/6.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

struct CategoryItem {
    var tag: Int
    var title: String?
    var backgroundColor: UIColor?
}

class CategoryView: UIScrollView {

    private let padding: CGFloat = 0.0
    public var lastViewX: CGFloat = 0.0
    private let buttonPadding = 0
    
    func add(target: UIViewController, categoryItem: CategoryItem) {
        
        // Creat and add Button.
        let button = UIButton()
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tag = categoryItem.tag
        button.setTitle(categoryItem.title, for: .normal)
        button.backgroundColor = categoryItem.backgroundColor
        button.sizeToFit()
        
        if button.frame.width < 120 {
            button.frame = CGRect(x: lastViewX, y: CGFloat(buttonPadding), width: 120, height: 45)
        } else {
            button.frame = CGRect(x: lastViewX, y: CGFloat(buttonPadding), width: button.frame.width + 20, height: 45)
        }
        lastViewX = lastViewX + button.frame.size.width
        
        button.addTarget(target, action: #selector(ProductPageViewController.buttonAction(_:)), for: .touchUpInside)
        
        buttonCorners(button: button)
        self.addSubview(button)
        self.contentSize = CGSize(width: lastViewX, height: self.frame.height)

    }

    // 設定 Button 圓角 (有可以決定只圓角哪個角落)
    func buttonCorners(button: UIButton) {
        let corners: UIRectCorner = [.topLeft, .topRight]
        button.corner(byRoundingCorners: corners, radii: 10)
    }
}

// 幫 UIButton 加上額外方法
extension UIButton {
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
