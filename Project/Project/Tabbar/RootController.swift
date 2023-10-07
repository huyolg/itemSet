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

    }
  
    
    func creatTabBar() {
        let tabBar = HConfig.loadConfigControllers("tabBar")
        var controllers:[UIViewController] = []
        for item in tabBar {
            let controllerName = item.controllerName
            let title = item.titleName
            
            let nav1 = UINavigationController(rootViewController: controllerName)
            nav1.tabBarItem.title = title
            if let icon = item.iconName {
                nav1.tabBarItem.image = UIImage(named: icon)
            }
            
            controllers.append(nav1)
        }
        
        viewControllers = controllers
        
    }

}
