//
//  UIColor+Extension.swift
//  Alamofire
//
//  Created by Mac027 on 2022/3/8.
//

import Foundation
import UIKit
extension UIColor {
    /// 随机颜色
    public static var random: UIColor {
        return UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 0.5)
    }
}
