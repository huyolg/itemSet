//
//  HNFCScanPage.swift
//  Project
//
//  Created by 胡某人 on 2023/10/17.
//

import UIKit
import SwiftUI

class HNFCScanPage: HBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NFC"
        
        backView()
        let scanView = HNFCReadView()
//        view.addSubview(scanView)
//        let hview = 
        let hons = UIHostingController(rootView: scanView)
        hons.view.frame = view.bounds
        print(hons)
        view.addSubview(hons.view)
        addChild(hons)
        hons.didMove(toParent: self)
    }
    



}
