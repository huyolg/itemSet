//
//  ViewController.swift
//  Project
//
//  Created by 胡永亮 on 2023/7/23.
//

import UIKit

class ViewController: HBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ble_vc = HBluetoothDeviceListController()
//        let nav_blue = UINavigationController(rootViewController: HBluetoothDeviceListController())
        
        self.navigationController?.pushViewController(ble_vc, animated: true)
    }

}

