//
//  Peripheral+Ext.swift
//  Project
//
//  Created by 胡某人 on 2023/7/26.
//

import Foundation
import CoreBluetooth

// MARK: CBPeripheral

private var rssiKey: String = "rssi"
private var connectBlockKey: String = "connectBlockKey"
private var advertisementDataKey: String = "advertisementDataKey"
private var discoverServicesBlockKey: String = "discoverServicesBlockKey"
private var discoverCharacteristicsBlockKey: String = "discoverCharacteristicsBlockKey"
private var updateValueBlockKey: String = "updateValueBlockKey"
private var IEEEAddressKey: String = "IEEEAddressKey"
private var companyIDKey: String = "companyIDKey"
private var systemIDKey: String = "systemIDKey"
private var interactIDKey: String = "interactIDKey"
extension CBPeripheral {
//
    var interactId: String? {
        get {
            return objc_getAssociatedObject(self, &interactIDKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &interactIDKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var companyID: String? {
        get {
            return objc_getAssociatedObject(self, &companyIDKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &companyIDKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var systemID: String? {
        get {
            return objc_getAssociatedObject(self, &systemIDKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &systemIDKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var IEEEAddress: String? {
        get {
            return objc_getAssociatedObject(self, &IEEEAddressKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &IEEEAddressKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var RSSI: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &rssiKey) as? NSNumber
        }
        set {
            objc_setAssociatedObject(self,
                                     &rssiKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var connectBlock: BLEConnectStateBlock? {
        get {
            return objc_getAssociatedObject(self, &connectBlockKey) as? BLEConnectStateBlock
        }
        set {
            objc_setAssociatedObject(self,
                                     &connectBlockKey, newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var advertisementData: [String : Any]? {
        get {
            return objc_getAssociatedObject(self, &advertisementDataKey) as? [String : Any]
        }
        set {
            objc_setAssociatedObject(self,
                                     &advertisementDataKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var discoverServicesBlock: EmptyBlock? {
        get {
            return objc_getAssociatedObject(self, &discoverServicesBlockKey) as? EmptyBlock
        }
        set {
            objc_setAssociatedObject(self,
                                     &discoverServicesBlockKey, newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var discoverCharacteristicsBlock: EmptyBlock? {
        get {
            return objc_getAssociatedObject(self, &discoverCharacteristicsBlockKey) as? EmptyBlock
        }
        set {
            objc_setAssociatedObject(self,
                                     &discoverCharacteristicsBlockKey, newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var updateValueBlock: DataBlock? {
        get {
            return objc_getAssociatedObject(self, &updateValueBlockKey) as? DataBlock
        }
        set {
            objc_setAssociatedObject(self,
                                     &updateValueBlockKey, newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var distance: String? {
        if let rssi = self.RSSI {
            let iRssi = abs(Int32(truncating: rssi))
            let power = (Float(iRssi) - 70) / (10 * 2.0)
            let distance = pow(10.0, power)
            return String(format: "%.2fm", distance)
        }
        return ""
    }
    
    var uuidString: String {
        return self.identifier.uuidString
    }
    
    var nameStr: String {
        return self.name ?? "设备未命名"
    }
    
        
    /** 扫描该外设的服务 */
    func discover(_ block: @escaping EmptyBlock, _ services: Array<CBUUID>? = nil) {
        discoverServicesBlock = block
        discoverServices(services)
    }
    /** 扫描该服务的特征 */
    func discover(service: CBService, _ block: @escaping EmptyBlock, _ characteristics: Array<CBUUID>? = nil) {
        discoverCharacteristicsBlock = block
        discoverCharacteristics(characteristics, for: service)
    }
    /** 获取该特征的数据 */
    func readValue(_ characteristic: CBCharacteristic, _ block: @escaping DataBlock) {
        updateValueBlock = block
        readValue(for: characteristic)
    }
    /** 是否订阅该外设的特征 */
    func setNotifyValue(_ enabled: Bool, _ characteristic: CBCharacteristic) {
        setNotifyValue(enabled, for: characteristic)
    }
}

