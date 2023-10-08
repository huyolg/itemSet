//
//  HBLECentralManager.swift
//  Project
//
//  Created by 胡某人 on 2023/7/26.
//

import UIKit
import CoreBluetooth


let companyIDs = ["060F"]
let systemIDs = ["4D43", "4941"]

enum BLEState {
    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
}

enum BLEConnectState {
    case connecting
    case connected
    case fail
    case disConnect
}

public let SystemFiltrateKey = "systemfiltrate"
public let CompanyFiltrateFiltrateKey = "companyfiltrate"

typealias BLEConnectStateBlock = ((BLEConnectState) -> ())
typealias EmptyBlock = (() -> ())
typealias DataBlock = ((Data) -> ())



 class HBLECentralManager: NSObject {
    static let shareInstance = HBLECentralManager()
    var centralManager:CBCentralManager?
    var peripheral:CBPeripheral?
    
    private var peripheralList: Array<CBPeripheral> = []
    private var connectedPeripheralList: Array<CBPeripheral> = []
    
    var scanBlock: (() -> ())?
    var peripherals: Array<CBPeripheral> {
        get {
            return peripheralList
        }
    }
    
    var state: BLEState?
    var BLEStateMsg: String = ""
    var overtime: Int = 5
    var stateUpdateBlock: ((BLEState) -> ())?
    var scanServiceBlock: (() -> ())?
//    重连取消
    var giveUpReconnectBlock: (() -> ())?
//    重连
    var reconnectBlock: (() -> ())?
    var connectFail: (() -> ())?
//    服务列表
    var serviceList:Array<CBService> = []
    var serviceCharacs:Array<CBCharacteristic> = []

    // 服务特征数据
    var serviceCharacteristics:Array<Array<CBCharacteristic>> = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
    }
    
    public func scanForPeripherals() {
        
        centralManager?.stopScan()
        peripheralList = []
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    /**停止扫描*/
    public func stopScan() {
        centralManager?.stopScan()
    }
    
    /** 连接外设 */
    public func connectToPeripheral(_ per: CBPeripheral) {
        centralManager?.connect(per, options: nil)
        DispatchQueue.main.async {
            if let block = per.connectBlock {
                block(.connecting)
            }
        }
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(overtime)) {
            if per.state == .connecting {
                print("连接超时")
                self.cancelConnectWithPeripheral(per)
            }
        }
    }
    /** 取消连接外设 */
    public func cancelConnectWithPeripheral(_ per: CBPeripheral) {
        disconnectWithPeripheral(per)
        DispatchQueue.main.async {
            if let block = self.connectFail {
                block()
            }
        }
    }
    /** 断开连接 */
    public func disconnectWithPeripheral(_ per: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(per)
        self.serviceCharacteristics = []
    }
    /**扫描服务*/
    public func connecttingService(_ per: CBPeripheral) {
        per.delegate = self
        per.discoverServices(nil)
    }
    // 获取MAC 地址
    func getMacAddress(_ peripheral: CBPeripheral) {
        let macServiceUUID = CBUUID(string: "180A")
        let macCharcteristicUUID = CBUUID(string: "2A23")
        
    }
}

extension HBLECentralManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("poweredOn")
        default:
            print("poweredOff")
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheral.RSSI = RSSI;

        if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
            if manufacturerData.count > 28 {
                //company id
                let companyCode = UInt16(manufacturerData[0]) + UInt16(manufacturerData[1]) << 8
                let companyID = String(format: "%04X", companyCode)
                
                // system id
                let systemCode = UInt16(manufacturerData[12]) + UInt16(manufacturerData[13]) << 8
                let systemID = String(format: "%04X", systemCode)
                
                // IEEE address
                let arrCode = manufacturerData.map { String(format: "%02x", $0) }
                let subArrCode = arrCode[2...9]
                let subStrCode = subArrCode.joined(separator: ":")
                
                // name
//                let nameCodes = arrCode[10...28]
//                let name = nameCodes.joined(separator: "")
//                let str = Utils.convertHexStr(to: name)
                
                
                peripheral.IEEEAddress = subStrCode
                
//                let InteractId = arrCode[2]
                peripheral.interactId = arrCode[2];
                
                //Name - LUMINAIRE_SHORT_NAME
//                let nameArrCode = arrCode[10...28]
                let nameStrCode = arrCode.joined(separator: "")
//                let newStr = Utils.convertHexStr(toData: nameStrCode)//string(fromHexString: nameStrCode)
//                print("arrCode = \(arrCode)")
//                print("arrCode = \(nameStrCode) uuid = \(peripheral.uuidString)")
//                print("kCBAdvDataManufacturerData = \(String(data: manufacturerData, encoding: .utf8))")
                
    
                if companyIDs.contains(companyID) {
                    peripheral.companyID = "\(companyID)"
                }
                
                if systemIDs.contains(systemID) {
                    peripheral.systemID = "\(systemID)"
                }
                                
                let hasBigPurchase = peripheralList.contains(peripheral)

                if !hasBigPurchase {
                    peripheralList.append(peripheral)
                }

                if let block = scanBlock {
                    DispatchQueue.main.sync {
                        
                        block()
                    }
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connect failed")
        if let block = peripheral.connectBlock {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.25) {
                DispatchQueue.main.sync {
                    block(.fail)
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connect success \(central) \n \(peripheral)")
        if !connectedPeripheralList.contains(peripheral) {
            connectedPeripheralList.append(peripheral)
        }
        if let block = peripheral.connectBlock {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.25) {
                DispatchQueue.main.sync {
                    block(.connected)
                }
            }
        }
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnect")
        if let block = peripheral.connectBlock {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.25) {
                DispatchQueue.main.sync {
                    block(.disConnect)
                }
            }
        }
        if connectedPeripheralList.contains(peripheral) {
            print("需要重新连接")
            DispatchQueue.main.sync {
                let VC = UIApplication.shared.keyWindow?.rootViewController
//                VC?.view.toast("已断开连接,请重连")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//                    VC?.view.hideLoading()
                    if ((VC?.isKind(of: UINavigationController.self)) != nil) {
                        let navVC = VC as! UINavigationController
                        let viewControllers = navVC.viewControllers
                        if  viewControllers.count > 1 {
                            navVC.popToRootViewController(animated: true)
                        }
                    }
                })

            }
        }
    }

}

// MARK: CBPeripheralDelegate
extension HBLECentralManager: CBPeripheralDelegate {
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("did read RSSI")
    }
    /** 扫描服务  */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            print("服务扫描失败 %s", err.localizedDescription)
        } else {
            if let services = peripheral.services {
                self.serviceList = services
                for service in services {
                    print("外设中的服务有：\(service)")
                    if service.uuid.uuidString.lowercased() == "941c0ae8-0000-4336-aede-f780803a0393" {
                        peripheral.discoverCharacteristics(nil, for: service)
                    }
                    
                    if service.uuid == CBUUID(string: "180A") {
//                        peripheral.discoverServices([CBUUID(string: "180A")])
                        peripheral.discoverCharacteristics(nil, for: service)
                    }
                }
            }
            
            if let block = peripheral.discoverServicesBlock {
                DispatchQueue.main.sync {
                    block()
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("modify services")
    }
    /** 扫描特征  */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            print("特征扫描失败 %s", err.localizedDescription)
        } else {
            if let characteristics = service.characteristics {
                serviceCharacteristics.append(characteristics)
                for character in characteristics {
                    if character.uuid == CBUUID(string: "2A23") {
                        peripheral.readValue(character) { response in
                            let arrCode = response.map { String(format: "%02x", $0) }
                            print("mac address = \(arrCode)")
                        }
                    }
//                    let prop = CBCharacteristicProperties(rawValue: character.properties.rawValue)
//                    print("外设中的特征有：\(character) \n")
                }
            }
            if let block = peripheral.discoverCharacteristicsBlock {
                DispatchQueue.main.sync {
                    block()
                }
            }
        }
    }
    /** 向外设写入数据回调 */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        peripheral.readValue(for: characteristic)
        if let err = error {
            DispatchQueue.main.sync {
                HBluetoothManager.shared.store.logText = "操作失败：\(err.localizedDescription)"
            }
           print("指令写入失败 --- \(err) --- \(characteristic) \n")
        }else {
            DispatchQueue.main.sync {
                HBluetoothManager.shared.store.logText = "操作成功：\(peripheral.uuidString)"
            }
            print("指令写入成功 --- \(characteristic) ---")
        }
    }
    /** 接收到外设发送的数据 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("接收外设数据 --\(String(describing: error))---")
        if let block = peripheral.updateValueBlock, let value = characteristic.value {
            DispatchQueue.main.sync {
                block(value)
            }
        }
    }
    /** 订阅状态 */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error {
            print("central订阅characteristic失败: \(err)")
            return
        }
        if characteristic.isNotifying {
            print("central订阅characteristic成功")
        } else {
            print("central取消订阅characteristic")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if let err = error {
            print("指令写入失败 --- \(err.localizedDescription) ---")
        }else {
            print("指令写入成功 --- \(descriptor) ---")
        }
    }
}

