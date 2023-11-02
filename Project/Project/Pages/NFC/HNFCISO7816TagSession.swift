//
//  HNFCISO7816TagSession.swift
//  Project
//
//  Created by 胡某人 on 2023/10/17.
//

import CoreNFC
import CoreBluetooth

class HNFCISO7816TagSession: NSObject {
    private var session: NFCTagReaderSession?
    private var sessionContinuation:CheckedContinuation<NFCISO7816Tag, Error>?
    
    func begin() async throws -> NFCISO7816Tag {
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "请将社保卡靠近手机背面的感应区"
        session?.begin()
        return try await withCheckedThrowingContinuation({[weak self] continuation in
            self?.sessionContinuation = continuation
        })
    }
    
    func invalidate(with message: String) {
        session?.alertMessage = message
        session?.invalidate()
    }
}

extension HNFCISO7816TagSession: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSessionDidBecomeActive")
    }

    /**
     扫描时出错。
     应用不再位于前台。
     用户选择取消扫描。
     应用取消了扫描。
     60s未读取到
     */
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("didInvalidateWithError")
        self.session = nil
        sessionContinuation?.resume(throwing: error)
    }
    // 成功读取
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("didDetect")
        //检测到 NFCISO7816Tag
        if let tag = tags.first, case .iso7816(let iso7816Tag) = tag {
            session.alertMessage = "正在读取信息，请勿移动卡片"
            // 连接到 NFCISO7816Tag ，并将同步调用形式转换成异步调用
            session.connect(to: tag) { [weak self] error in
                if let error {
                    self?.sessionContinuation?.resume(throwing: error)
                } else {
                    self?.sessionContinuation?.resume(returning: iso7816Tag)
                }
            }
        }
    }
    
    
}
