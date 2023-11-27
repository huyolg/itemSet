//
//  HVideoCapture.swift
//  Project
//
//  Created by 胡某人 on 2023/11/8.
//

import UIKit
import AVFoundation

enum HVideoCaptureError: Error {
    case session
    case unkwon
}

class HVideoCapture: NSObject {
    private(set) var config: HVideoCoderConfig
    
    
    init(config: HVideoCoderConfig) {
        self.config = config
    }
}

extension HVideoCapture {
    private func updateCapture() {
        config = HVideoCoderConfig()
    }
}
