//
//  HBluetoothDeviceModel.swift
//  Project
//
//  Created by 胡某人 on 2023/7/26.
//

import UIKit

class HBluetoothDeviceModel: NSObject {

    var interactId: String = ""
    
    var companyID: String = ""
    var systemID: String = ""
    var IEEEAddress: String = ""
    var RSSI: NSNumber = 0
    
    var advertisementData: [String : Any] = [:]
    
    
    var distance: String? {
        let iRssi = abs(Int32(truncating: self.RSSI))
        let power = (Float(iRssi) - 70) / (10 * 2.0)
        let distance = pow(10.0, power)
        return String(format: "%.2fm", distance)
    }
    
    var uuidString: String = ""
    
    var nameStr: String = ""
        
    
            

}
