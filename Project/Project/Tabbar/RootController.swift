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


private var isAnimating = false

extension UITabBar {
    // 显示｜隐藏 TabBar 方法
    func changeTabBar(hidden:Bool, animated: Bool){
        if isAnimating { return }   // 如果动画正在执行，则不执行！
        if self.isHidden == hidden { return }  // 如果已经是指定隐藏状态，则不执行！
        
        /*=========================================*/
        // 修复在TabBar隐藏的情况下，旋转屏幕动画错乱的Bug!
        if self.isHidden {
            self.frame = CGRect(
                x: frame.minX,
                y: UIScreen.main.bounds.height,
                width: frame.width,
                height: frame.height
            ) // 强行修改tabBar的Frame
        }
        /*=========================================*/
        
        let frame = self.frame  // 获取自身的frame
        let isOutScreen = Int(UIScreen.main.bounds.height - self.frame.minY) == 0   // 是否在屏幕外面，以此为判断动画方向的依据！
        let a: CGFloat = isOutScreen ? -1 : 1   // 定义动画方向 | 上下
        let offset = a * frame.size.height  // 设置动画偏移量
        let duration: TimeInterval = (animated ? 0.5 : 0.0) // 定义动画持续时间
        
        self.isHidden = false // 开始动画之前，先开启tabBar的显示！
        isAnimating = true // 标记动画【正在执行】状态
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.center.y += offset // 改变【中心点】偏移量！
            }) { _ in
            self.isHidden = !isOutScreen    // 设置tabBar的显示状态
            isAnimating = false // 取消动画【正在执行】状态
        }
    }
}
