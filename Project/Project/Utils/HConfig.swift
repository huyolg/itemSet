//
//  HConfig.swift
//  Project
//
//  Created by 胡某人 on 2023/10/7.
//

import UIKit

struct PageConfig: Identifiable,Hashable {
    var id = UUID()
    
    var iconName: String?
    var titleName: String
    var controllerName: UIViewController
}

class HConfig: NSObject {

    static func loadConfigControllers(_ key: String) -> [PageConfig] {
        if key.isEmpty {
            return []
        }
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")
        do {
            let fileUrl = URL(fileURLWithPath: path ?? "")
            let data = try! Data(contentsOf: fileUrl)
            
            guard let plistData = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: [[String:String]]], let tabBar = plistData[key] else { return [] }
            
            var controllers:[PageConfig] = []
            for item in tabBar {
                let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String//这是获取项目的名称，
                           
                if let controllerName = item["controllerName"], let title = item["titleName"] {
                    let icon = item["iconName"] ?? ""
                    let className = name! + "." + controllerName
                    guard let controller = NSClassFromString(className) as? UIViewController.Type else {
                        return []
                    }
                    let vc = controller.init()
                    let model = PageConfig(iconName: icon, titleName: title, controllerName: vc)
                    
                    controllers.append(model)
                }
            }
            return controllers
        }
    }
}
