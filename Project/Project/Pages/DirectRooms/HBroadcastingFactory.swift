//
//  HBroadcastingFactory.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit

enum HBroadcastingType {
    case RTC, VideoToolBox, Other
}

struct HBroadcastingFactory {
    
    static func factory(_ type: HBroadcastingType) -> UIView {
        switch type {
        case .RTC:
            return factoryRtc()
        case .VideoToolBox:
            return factoryVideoToolBox()
        case .Other:
            return factoryOther()
        }
    }
    
    static func factoryRtc() -> UIView {
        let room = HRTCRoomView()
        return room
    }
    
    static func factoryVideoToolBox() -> UIView {
        let room = HToolBoxRoomView()
        return room
    }
    
    static func factoryOther() -> UIView {
        let room = HRTCRoomView()
        return room
    }
}

//class HBroadcastingFactory: NSObject {
//
//}


