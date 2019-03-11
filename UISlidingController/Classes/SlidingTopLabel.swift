//
//  SlidingTopLabel.swift
//  UIScrollerControl_Swift
//
//  Created by auger on 2019/3/11.
//  Copyright © 2019 HuaSuan. All rights reserved.
//

/// 滑动顶部标签

import UIKit

class SlidingTopLabel: UILabel {

    enum ColorType {
        case background, text
    }
    
    var isSelected: Bool = false {
        didSet {
            setOffset(isSelected ? 0 : 1)
        }
    }
    
    var item: UITopBarItem?
    
    private var fontSize: CGFloat = 13 {
        didSet {
            font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    private func config() {
        textAlignment = .center
        backgroundColor = UIColor.white
        isUserInteractionEnabled = true
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func setOffset(_ offset: CGFloat) {
        guard let item = self.item else {
            return
        }
        if offset >= 1  {
            fontSize = item.normalFontSize
            textColor = item.normalTextColor
            backgroundColor = item.normalBackgroundColor
        }else if offset <= 0  {
            fontSize = item.selectedFontSize
            textColor = item.selectedTextColor
            backgroundColor = item.selectedBackgroundColor
        }else {
            if item.normalFontSize != item.selectedFontSize {
                fontSize = item.selectedFontSize + (item.normalFontSize - item.selectedFontSize) * offset
            }
            if item.normalTextColor != item.selectedTextColor {
                setColor(offset: offset, type: .text)
            }
            if item.normalBackgroundColor != item.selectedBackgroundColor {
                setColor(offset: offset, type: .background)
            }
        }
        
    }
    
    fileprivate func setColor(offset: CGFloat, type: ColorType) {
        guard let item = item else {
            return
        }
        let beganColor = type == .background ? item.selectedBackgroundColor : item.selectedTextColor
        let endColor = type == .background ? item.normalBackgroundColor : item.normalTextColor
        
        let r1 = beganColor.r
        let g1 = beganColor.g
        let b1 = beganColor.b
        let a1 = beganColor.a
        
        let r2 = endColor.r
        let g2 = endColor.g
        let b2 = endColor.b
        let a2 = endColor.a
        
        let r = r1 + (r2 - r1) * offset
        let g = g1 + (g2 - g1) * offset
        let b = b1 + (b2 - b1) * offset
        let a = a1 + (a2 - a1) * offset
        
        
        let currentColor = UIColor(r: r, g: g, b: b, a: a)
        switch type {
        case .background:
            backgroundColor = currentColor
        case .text:
            textColor = currentColor
        }
    }

}
