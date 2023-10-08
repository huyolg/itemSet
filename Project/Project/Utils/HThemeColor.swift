//
//  HThemeColor.swift
//  Project
//
//  Created by 胡某人 on 2023/10/8.
//

import UIKit


struct HThemeColor {
    static var white: UIColor {
        get {
            return UIColor(0xffffff)
        }
    }
    static var theme: UIColor {
        get {
            let col = UIColor(0x3C3C41)
            return col
        }
    }
//    涂鸦色
    static var doodingColor: UIColor {
        get {
            return UIColor(0x00e488)
        }
    }
    static var disabledColor: UIColor {
        get {
            return UIColor(0x5D5D61)
        }
    }
///    按钮置灰色
    static var disabled: UIColor {
        get {
            return UIColor(0x8E8E94)
        }
    }
    
    static var gray: UIColor {
        get {
            return UIColor(red: 27 / 255, green: 27 / 255, blue: 31 / 255, alpha: 0.6)
        }
    }
}

public func hexcolor(_ hex : UInt) -> UIColor {
    return UIColor.init(hex)
}

extension UIColor {
    convenience init(_ hex : UInt) {
        let b = CGFloat(hex & 0xff) / 255.0
        let g = CGFloat((hex >> 8) & 0xff) / 255.0
        let r = CGFloat((hex >> 16) & 0xff) / 255.0
        let a = hex > 0xffffff ? CGFloat((hex >> 24) & 0xff) / 255.0 : 1.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
