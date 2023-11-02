//
//  HNFCTag.swift
//  Project
//
//  Created by 胡某人 on 2023/10/17.
//


import CoreNFC
import CryptoSwift

extension NFCISO7816Tag {
    @discardableResult
    func sendCommand(_ command: String) async throws -> Data {
        return try await withCheckedThrowingContinuation({ continuation in
            // 通过CryptoSwift 提供的API，将16进制表示命令的字符串转成字节
            let apdu = NFCISO7816APDU(data: Data(hex: command))!
            // 将同步调用形式转换成异步调用
            sendCommand(apdu: apdu) { resData, _, _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: resData)
                }
            }
        })
    }
}
