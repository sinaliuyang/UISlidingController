//
//  Extension_UIColor.swift
//  UIScrollerControl_Swift
//
//  Created by auger on 2019/3/11.
//  Copyright © 2019 HuaSuan. All rights reserved.
//

/// 扩展UICOlor

import UIKit

//MARK: - 获取RGB值
extension UIColor {
    var r: CGFloat {
        var value: CGFloat = 1
        getRed(&value, green: nil, blue: nil, alpha: nil)
        return value * 255
    }
    
    var g: CGFloat {
        var value: CGFloat = 1
        getRed(nil, green: &value, blue: nil, alpha: nil)
        return value * 255
    }
    
    var b: CGFloat {
        var value: CGFloat = 1
        getRed(nil, green: nil, blue: &value, alpha: nil)
        return value * 255
    }
    
    var a: CGFloat {
        var alpha: CGFloat = 1.0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }
    
    /// 通过RGBA值初始化颜色
    ///
    /// - Parameters:
    ///   - r: 红(0~255)
    ///   - g: 绿(0~255)
    ///   - b: 蓝(0~255)
    ///   - a: 透明度(0~1.0)
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat = 1.0) {
        self.init(red: (r / 255.0), green: (g / 255.0), blue: (b / 255.0), alpha: a)
    }
    
    
    /// 通过Int值初始化颜色
    ///
    /// - Parameters:
    ///   - hex: 颜色值(0x000000~0xFFFFFF)
    ///   - alpha: 透明度(0~1.0)
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = (CGFloat(((hex & 0xFF0000) >> 16)) / 255.0)
        let green = (CGFloat(((hex & 0xFF00) >> 8)) / 255.0)
        let blue = (CGFloat((hex & 0xFF)) / 255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
