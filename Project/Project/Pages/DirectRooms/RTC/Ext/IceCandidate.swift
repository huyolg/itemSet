//
//  IceCadidate.swift
//  Project
//
//  Created by 胡某人 on 2023/11/2.
//

import UIKit
import WebRTC

struct IceCandidate: Codable {
    let sdp: String
    let sdpMind: String?
    let sdpMLineIndex: Int32
    
    init(from ice: RTCIceCandidate) {
        self.sdp = ice.sdp
        self.sdpMind = ice.sdpMid
        self.sdpMLineIndex = ice.sdpMLineIndex
    }
    
    var rtcIceCandidate: RTCIceCandidate {
        return RTCIceCandidate(sdp: self.sdp, sdpMLineIndex: self.sdpMLineIndex, sdpMid: self.sdpMind)
    }
}
