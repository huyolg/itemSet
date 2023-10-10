//
//  HSocketViewModel.swift
//  Project
//
//  Created by 胡某人 on 2023/10/10.
//

import UIKit
import CocoaAsyncSocket

let kHost = "127.0.0.1"
let kPort:UInt16 = 8888

class HSocketViewModel: NSObject {
    
    
    var gcdSocket: GCDAsyncSocket?
    var gcdUDPSocket: GCDAsyncUdpSocket?
    

    func runTCP() {
        gcdSocket = GCDAsyncSocket(delegate: self, delegateQueue: .main)
    }
    
    func runUDP() {
        gcdUDPSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
    }
    
    public func sendMsg(_ msg: String) {
        let texts = ["hello", "天气很好", "吃了吗", "去哪玩"]
        for item in texts {
            let textData = item.data(using: .utf8)
            if let data = textData {
                sendData(data, type: "txt")
            }
        }
        
    }
    
    public func connect() {
        do {
            let connected = try gcdSocket?.connect(toHost: kHost, onPort: kPort, withTimeout: 10)
            print("net connect is \(String(describing: connected))")
        } catch {
            
        }
    }
    
    public func disconnect() {
        gcdSocket?.disconnect()
    }
    
    func sendData(_ data: Data, type:String) {
        let dataSize = data.count
        let headDic:[String: String] = [
            "type": type,
            "size": "\(dataSize)"
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: headDic, options: .prettyPrinted)
//            let jsonStr = String(data: jsonData, encoding: .utf8)
            
            var mData = Data()
            mData.append(jsonData)
            mData.append(GCDAsyncSocket.crlfData())
            mData.append(data)
            // 第二个参数，请求超时时间
            gcdSocket?.write(mData, withTimeout: -1, tag: 110)
        } catch {
            
        }
        
    }
    // 监听最新消息
    func pullTheMsg() {
        // 监听读数据的代理，只能监听10秒，10秒过后调用代理方法  -1永远监听，不超时，但是只收一次消息，
        // 所以每次接受到消息还得调用一次
        gcdSocket?.readData(withTimeout: -1, tag: 110)
    }
    
    func checkPingPong() {
        // pingpong设置为3秒，如果3秒内没得到反馈就会自动断开连接
        gcdSocket?.readData(withTimeout: 3, tag: 110)
    }
}

extension HSocketViewModel: GCDAsyncSocketDelegate {
    // 链接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("TCP socket connected \(host) : \(port)")
        
        sock.startTLS(nil)
        // 心跳数据
    }
    // 链接失败
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("TCP socket connect error \(String(describing: err))")
        // 断线重连
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("这里写回调")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("收到消息 \(data)")
    }
    
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        print("didReadPartialDataOfLength")
    }
    // 为上一次设置的读取数据代理续时 (如果设置超时为-1，则永远不会调用到)
    func socket(_ sock: GCDAsyncSocket, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
        print("delay \(elapsed)")
        return 10
    }
}

extension HSocketViewModel: GCDAsyncUdpSocketDelegate {
    
}
