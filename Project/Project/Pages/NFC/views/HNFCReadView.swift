//
//  HNFCReadView.swift
//  Project
//
//  Created by 胡某人 on 2023/10/17.
//

import SwiftUI
import CryptoSwift

struct HNFCReadView: View {
    @State private var cardNo = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("卡号：\(cardNo)")
                .font(.system(size: 17))
            Button(action: read) {
                if #available(iOS 15.0, *) {
                    Text("读取")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(8)
                } else {
                    // Fallback on earlier versions
                }
            }
            Spacer()
        }
        .padding()
    }
    
    private func read() {
        Task {
            let session = HNFCISO7816TagSession()
            do {
                // 检测 HNFCISO7816Tag
                let tag = try await session.begin()
                
                let cardNo = try await tag.sendCommand("00B0950A12")[0..<10].toHexString()
                self.cardNo = cardNo
                // 关闭会话
                session.invalidate(with: "读取成功")
            } catch {
                print("读取异常 = ", error)
            }
        }
    }
}

struct HNFCReadView_Previews: PreviewProvider {
    static var previews: some View {
        HNFCReadView()
    }
}
