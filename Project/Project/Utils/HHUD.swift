//
//  HHUD.swift
//  Project
//
//  Created by 胡某人 on 2023/10/8.
//

import UIKit
import ProgressHUD

class HHUD: NSObject {
    public enum Status : Int, @unchecked Sendable {
        case successed = 0
        case failed = 1
        case error = 2
    }
    
    static func show(_ tips: String? = nil) {
        ProgressHUD.show(tips)
    }
    
    static func showStatus(_ tips: String? = nil, status: Status) {
        switch status {
        case .successed:
            ProgressHUD.showSucceed(tips)
        case .failed:
            ProgressHUD.showFailed(tips)
        case .error:
            ProgressHUD.showError(tips)
        }
    }
    

    static func hidden() {
        ProgressHUD.dismiss()
    }
}
