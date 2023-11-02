//
//  SignalingClient.swift
//  Project
//
//  Created by 胡某人 on 2023/11/2.
//

import UIKit
import WebRTC

protocol SignalClientDelegate: NSObjectProtocol {
    func signalClient(didConnected signalClient: SignalingClient)
    func signalClient(didDisconnected signalClient: SignalingClient)
    func signalClient(_ signalClient: SignalingClient, didReceiceRemoteSdp sdp: RTCSessionDescription)
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate)
}



final class SignalingClient {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var webSocket: WebSocketProvider
    weak var delegate: SignalClientDelegate?
    
    init(webSocket: WebSocketProvider) {
        self.webSocket = webSocket
    }
    
    func connect() {
        webSocket.delegate = self
        webSocket.connect()
    }
    
    func send(sdp rtcSdp: RTCSessionDescription) {
        let message = Message.sdp(SessionDescription(from: rtcSdp))
        do {
            let dataMsg = try encoder.encode(message)
            webSocket.send(data: dataMsg)
            
        } catch {
            debugPrint("Error: Could not encode sdp: \(error)")
        }
    }
    
    func send(candidate rtcIceCandidate: RTCIceCandidate) {
        let message = Message.candidate(IceCandidate(from: rtcIceCandidate))
        do {
            let dataMsg = try encoder.encode(message)
            webSocket.send(data: dataMsg)
        } catch {
            debugPrint("Error: Could not encode candidate: \(error)")
        }
    }
}

extension SignalingClient: WebSocketProviderDelegate {
    func webSocketDidConnect(_ webSocket: WebSocketProvider) {
        delegate?.signalClient(didConnected: self)
    }
    
    func webSocketDidDisconnect(_ webSocket: WebSocketProvider) {
        delegate?.signalClient(didDisconnected: self)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {[weak self] in
            debugPrint("Trying to reconnect to signaling server...")
            self?.webSocket.connect()
        }
    }
    
    func webSocket(_ webSocket: WebSocketProvider, didReceiveData data: Data) {
        let message: Message
        do {
            message = try decoder.decode(Message.self, from: data)
        } catch {
            debugPrint("Error: Could not decode incoming message: \(error)")
            return
        }
        
        switch message {
        case .sdp(let sesstionDescription):
            delegate?.signalClient(self, didReceiceRemoteSdp: sesstionDescription.rtcSessionDescription)
        case .candidate(let iceCandidate):
            delegate?.signalClient(self, didReceiveCandidate: iceCandidate.rtcIceCandidate)
        }
    }
}

