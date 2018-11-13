//
//  UIImage+Resize.swift
//  HelloMyPushMessage
//
//  Created by Nick Wen on 2018/10/26.
//  Copyright © 2018 Nick Wen. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(maxEdge: CGFloat) -> UIImage? {
        //確認圖片寬與高是否有超過maxEdge,確認是否有必要resize
        guard size.width >= maxEdge || size.height >= maxEdge else {
            return self
        }
        //判斷寬高誰比較大,大者為最長邊
        let finalSize:CGSize
        if size.width >= size.height {
            let ratio = size.width / maxEdge
            finalSize = CGSize(width: maxEdge, height: size.height / ratio)
        } else {//高大於寬
            let ratio = size.height / maxEdge
            finalSize = CGSize(width: size.width / ratio, height: maxEdge)
        }
        
        //實際產出一個新圖
        UIGraphicsBeginImageContext(finalSize)//產生一個油畫畫布
        let rect = CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height)//決定畫布寬高
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()// Important 避免記憶體洩漏
        return result
        
    }
}
