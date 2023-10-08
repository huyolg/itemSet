//
//  HStore.swift
//  Project
//
//  Created by 胡某人 on 2023/7/26.
//

import UIKit

class HStore: NSObject {
    var _logText = ""
    var date: Date {
        get {
            return Date()
        }
    }
    @objc dynamic var logText: String = ""
    
//    func conbinStr() {
//        self.logText = "\(date)" + self.logText
//    }
}
