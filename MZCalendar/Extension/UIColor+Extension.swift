//
//  UIColor+Extension.swift
//  MZCalendar
//
//  Created by Jerry.li on 2018/10/17.
//  Copyright © 2018年 51app. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    /// 十六进制颜色码转换UIColor
    ///
    /// - Parameters:
    ///   - hex: 十六进制颜色码
    ///   - aplha: 透明度
    /// - Returns: UIColor
    class func hexString(hex: String, aplha: CGFloat) -> UIColor {
        var tempHex = hex
        
        if tempHex == "0" {
            return UIColor.clear //如果为"0",就认为是透明色
        }
        
        //是否有#前缀
        if tempHex.hasPrefix("#") {
            tempHex = tempHex.subString(start: 1)
        }
        
        let scanner:Scanner = Scanner(string: tempHex)
        var valueRGB:UInt32 = 0
        if scanner.scanHexInt32(&valueRGB) == false {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            return UIColor.init(
                red: CGFloat((valueRGB & 0xFF0000)>>16)/255.0,
                green: CGFloat((valueRGB & 0x00FF00)>>8)/255.0,
                blue: CGFloat(valueRGB & 0x0000FF)/255.0,
                alpha: aplha)
        }
    }
    
    //16进制字符串设置颜色
    class func hexString(hex:String) -> UIColor {
        return hexString(hex: hex, aplha: 1.0)
    }
    
}
