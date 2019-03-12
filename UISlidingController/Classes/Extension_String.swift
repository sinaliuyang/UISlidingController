//
//  Extension_String.swift
//  UIScrollerControl_Swift
//
//  Created by auger on 2019/3/11.
//  Copyright © 2019 HuaSuan. All rights reserved.
//

/// 拓展String
import UIKit

//MARK: - 尺寸计算
extension String {
    
    func rect(font: UIFont, estimatedSize size: CGSize, drawingOption option: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGRect {
        let attributes = [NSAttributedStringKey.font: font]//[NSAttributedString.Key.font: font]
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
    
    func size(font: UIFont, estimatedSize size: CGSize, drawingOption option: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        return self.rect(font: font, estimatedSize: size, drawingOption: option).size
    }
    
    func singleLineSize(font:UIFont, drawingOption option: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        let maxValue = CGFloat.greatestFiniteMagnitude
        return self.rect(font: font, estimatedSize: CGSize(width: maxValue, height: maxValue), drawingOption: option).size
    }
    
    func height(font:UIFont, maxWidth: CGFloat, drawingOption option: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGFloat {
        let maxValue = CGFloat.greatestFiniteMagnitude
        return self.rect(font: font, estimatedSize: CGSize(width: maxWidth, height: maxValue), drawingOption: NSStringDrawingOptions.usesLineFragmentOrigin).size.height
    }
    
    func width(font:UIFont, maxHeight: CGFloat, drawingOption option: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGFloat {
        let maxValue = CGFloat.greatestFiniteMagnitude
        return self.rect(font: font, estimatedSize: CGSize(width: maxValue, height: maxHeight), drawingOption: NSStringDrawingOptions.usesLineFragmentOrigin).size.width
    }
    
}
