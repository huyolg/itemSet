//
//  SessionDescription.swift
//  Project
//
//  Created by 胡某人 on 2023/11/2.
//

import UIKit
import WebRTC

enum SdpType: String, Codable {
    case offer, prAnswer, answer

    var retSdpType: RTCSdpType {
        switch self {
        case .answer:
            return .answer
        case .offer:
            return .offer
        case .prAnswer:
            return .prAnswer
        }
    }
}

struct SessionDescription: Codable {
    let sdp: String
    let type: SdpType

    init(from rtcSessionDescription: RTCSessionDescription) {
        self.sdp = rtcSessionDescription.sdp
        switch rtcSessionDescription.type {
        case .offer:
            self.type = .offer
        case .answer:
            self.type = .answer
        case .prAnswer:
            self.type = .prAnswer
        default:
            fatalError("Unknown RTCSessionDescription type: \(rtcSessionDescription.type.rawValue)")
        }
    }

    var rtcSessionDescription: RTCSessionDescription {
        return RTCSessionDescription(type: self.type.retSdpType, sdp: self.sdp)
    }
}


