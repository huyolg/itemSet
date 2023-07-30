//
//  TabBarController.swift
//  Project
//
//  Created by 胡永亮 on 2023/7/23.
//

import UIKit
@objc
class RootController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        creatTabBar()
//        guard let controller = NSClassFromString("HHomeViewController") as? UIViewController.Type else {
//            return
//        }
//        let homeVC = controller.init()
//        let home_nav = UINavigationController(rootViewController: homeVC)
//        home_nav.tabBarItem.title = "home"
//
//        let homeVC1 = UIViewController()
//        let home_nav1 = UINavigationController(rootViewController: homeVC1)
//        home_nav1.tabBarItem.title = "other"
//
//        viewControllers = [home_nav,home_nav1]
    }
    
    func creatTabBar() {
        let path = Bundle.main.path(forResource: "Config", ofType: "plist")
        do {
            let fileUrl = URL(filePath: path ?? "")
            let data = try! Data(contentsOf: fileUrl)
            
            
            guard let plistData = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: [[String:String]]], let tabBar = plistData["tabBar"] else { return }
            
            print(tabBar)
            var controllers:[UIViewController] = []
            for item in tabBar {
                var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String//这是获取项目的名称，
                           
                name = name?.replacingOccurrences(of: "-", with: "_")
                let className = name! + "." + item["controllerName"]!
                if let controllerName = item["controllerName"], let iconName = item["iconName"], let title = item["titleName"] {
                    guard let controller = NSClassFromString(controllerName) as? UIViewController.Type else {
                        return
                    }
                    let vc = controller.init()
                    vc.title = "啥名字"
                    let nav1 = UINavigationController(rootViewController: vc)
                    nav1.tabBarItem.title = title
                    
//                    addChild(nav1)
                    controllers.append(nav1)
                    
                }

            }
            
            viewControllers = controllers
        }
        
    }

}
