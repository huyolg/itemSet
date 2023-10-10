//
//  HToolBoxRoomView.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit

class HToolBoxRoomView: HBroadcastingRoomView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // 创建编码会话
        
    }
    
}
