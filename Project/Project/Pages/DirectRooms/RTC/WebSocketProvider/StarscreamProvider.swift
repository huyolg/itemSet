//
//  StarscreamProvider.swift
//  Project
//
//  Created by 胡某人 on 2023/11/2.
//

import UIKit
import Starscream

class StarscreamWebSocket: WebSocketProvider {

    var delegate: WebSocketProviderDelegate?
    private let socket: WebSocket
    
    init(url: URL) {
        let urlRuest = URLRequest(url: url)
        let engi = Engine.self
        self.socket = WebSocket(request: urlRuest)
        self.socket.delegate = self
    }
    
    func connect() {
        self.socket.connect()
    }
    
    func send(data: Data) {
        self.socket.write(data: data)
    }
}

extension StarscreamWebSocket: Starscream.WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        self.delegate?.webSocketDidConnect(self)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.delegate?.webSocketDidDisconnect(self)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        debugPrint("Warning: Expected to receive data format but received a string. Check the websocket server config.")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        self.delegate?.webSocket(self, didReceiveData: data)
    }    
}
