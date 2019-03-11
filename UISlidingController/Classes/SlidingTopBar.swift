//
//  SlidingTopBar.swift
//  UIScrollerControl_Swift
//
//  Created by auger on 2019/3/11.
//  Copyright © 2019 HuaSuan. All rights reserved.
//

/// 顶部信息

import UIKit

class SlidingTopBar: NSObject {
    /// 高度
    var height: CGFloat = 44.0
    /// 文字距离边缘的距离
    var itemSpace: CGFloat = 12.0
    /// 是否有滑块(默认有)
    var isHasSlider = true
    /// 滑块颜色
    var sliderColor = UIColor.red
    /// 是否自动标题宽度
    var isScrollEnable = true
    /// item属性
    var item = UITopBarItem()
    /// 分隔线颜色
    var separateLineColor = UIColor.clear
}

class UITopBarItem: NSObject {
    /// 默认字体
    var normalFontSize: CGFloat = 14
    /// 选中字体
    var selectedFontSize: CGFloat = 16
    /// 默认文本颜色
    var normalTextColor = UIColor.black
    /// 选中文本颜色
    var selectedTextColor = UIColor.black
    /// 普通背景颜色
    var normalBackgroundColor = UIColor.white
    /// 选中背景颜色
    var selectedBackgroundColor = UIColor.white
    
    var normalFont: UIFont {
        return UIFont.systemFont(ofSize: normalFontSize)
    }
    var selectedFont: UIFont {
        return UIFont.systemFont(ofSize: normalFontSize)
    }
} 
