//
//  HBluetoothDeviceListController.swift
//  Project
//
//  Created by 胡某人 on 2023/7/25.
//

import UIKit
import CoreBluetooth

class HBluetoothDeviceListController: HBaseViewController {
    
    var centralManager:CBCentralManager?
//    var centralManager: HBLECentralManager?
    var peripheral:CBPeripheral?
    
    
    var dataSource:[CBPeripheral] = []
    
    lazy var tabView: UITableView = {
        let tbv = UITableView(frame: CGRect.zero, style: .plain)
        tbv.automaticallyAdjustsScrollIndicatorInsets = false
        tbv.register(HBluetoothDeviceCell.self, forCellReuseIdentifier: "HBluetoothDeviceCell")
        tbv.delegate = self
        tbv.dataSource = self
        return tbv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设备列表"
        
        view.backgroundColor = UIColor.white
        
        let btn = UIButton(type: .custom)
        btn.setTitle("Scan", for: .normal)
        btn.bounds = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        btn.addTarget(self, action: #selector(scanForPeripherals), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        tabView.frame = view.bounds
        view.addSubview(tabView)
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        scanForPeripherals()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScan()
    }
    
    /** 扫描设备 */
    @objc func scanForPeripherals() {
        let state = centralManager?.state
        if state == .poweredOn {
            centralManager?.stopScan()
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    /** 停止扫描 */
    func stopScan() {
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
//        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(overtime)) {
//            if per.state == .connecting {
//                print("连接超时")
//                self.cancelConnectWithPeripheral(per)
//            }
//        }
    }
    /** 取消连接外设 */
    public func cancelConnectWithPeripheral(_ per: CBPeripheral) {
        disconnectWithPeripheral(per)
//        DispatchQueue.main.async {
//            if let block = self.connectFail {
//                block()
//            }
//        }
    }
    /** 断开连接 */
    public func disconnectWithPeripheral(_ per: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(per)
//        self.serviceCharacteristics = []
    }
}

extension HBluetoothDeviceListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HBluetoothDeviceCell = tableView.dequeueReusableCell(withIdentifier: "HBluetoothDeviceCell", for: indexPath) as! HBluetoothDeviceCell
        if dataSource.count > indexPath.row {
            cell.item = dataSource[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count <= indexPath.row {
            return
        }
        let item = dataSource[indexPath.row]
        connectToPeripheral(item)
    }
    
    
}
 
extension HBluetoothDeviceListController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("poweredOn")
            scanForPeripherals()
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
    
                if companyIDs.contains(companyID) {
                    peripheral.companyID = "\(companyID)"
                }
                
                if systemIDs.contains(systemID) {
                    peripheral.systemID = "\(systemID)"
                }
                                
                let hasBigPurchase = dataSource.contains(peripheral)

                if !hasBigPurchase {
                    dataSource.append(peripheral)
                }

                tabView.reloadData()
//                if let block = scanBlock {
//                    DispatchQueue.main.sync {
//
//                        block()
//                    }
//                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connect failed")
//        if let block = peripheral.connectBlock {
//            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.25) {
//                DispatchQueue.main.sync {
//                    block(.fail)
//                }
//            }
//        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connect success \(central) \n \(peripheral)")
//        if !connectedPeripheralList.contains(peripheral) {
//            connectedPeripheralList.append(peripheral)
//        }
//        if let block = peripheral.connectBlock {
//            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.25) {
//                DispatchQueue.main.sync {
//                    block(.connected)
//                }
//            }
//        }
//        peripheral.delegate = self
//        peripheral.discoverServices(nil)
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
//        if connectedPeripheralList.contains(peripheral) {
//            print("需要重新连接")
//            DispatchQueue.main.sync {
//                let VC = UIApplication.shared.keyWindow?.rootViewController
////                VC?.view.toast("已断开连接,请重连")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
////                    VC?.view.hideLoading()
//                    if ((VC?.isKind(of: UINavigationController.self)) != nil) {
//                        let navVC = VC as! UINavigationController
//                        let viewControllers = navVC.viewControllers
//                        if  viewControllers.count > 1 {
//                            navVC.popToRootViewController(animated: true)
//                        }
//                    }
//                })
//
//            }
//        }
    }
}

extension HBluetoothDeviceListController: CBPeripheralDelegate {
    
}
