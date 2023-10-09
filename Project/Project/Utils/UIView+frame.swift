//
//  UIView+frame.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit

extension UIView {
    var width: CGFloat {
        get {
            return frame.size.width
        }
    }
    var heiht: CGFloat {
        get {
            return frame.size.height
        }
    }
    var x: CGFloat {
        get {
            return frame.origin.x
        }
    }
    var y: CGFloat {
        get {
            return frame.origin.y
        }
    }
    var right: CGFloat {
        get {
            return x + width
        }
    }
    var bottom: CGFloat {
        get {
            return y + heiht
        }
    }
}
