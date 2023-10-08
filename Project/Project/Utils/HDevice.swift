//
//  HDevice.swift
//  Project
//
//  Created by 胡某人 on 2023/10/8.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let TabBarHeight: CGFloat = 49.0
let NavigationBarHeight: CGFloat = 44.0

struct HDevice {
    // 状态栏高度
    static var statBarHeight: CGFloat {
        get {
            var height:CGFloat = 0.0
            if #available(iOS 13, *){
                let scene = UIApplication.shared.connectedScenes.first
                guard let windowScene = scene as? UIWindowScene else { return 0 }
                guard let statusBarManager = windowScene.statusBarManager else { return 0 }
                height = statusBarManager.statusBarFrame.height
            } else {
                height = UIApplication.shared.statusBarFrame.height
            }
            
            return height
        }
    }
    
    // 顶部安全距离高度
    static var safeDistanceTopHeight: CGFloat {
        get {
            var height:CGFloat = 0.0
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                guard let windowScene = scene as? UIWindowScene else { return 0 }
                guard let window = windowScene.windows.first else { return 0 }
                height = window.safeAreaInsets.top
            } else {
                guard let window = UIApplication.shared.windows.first else { return 0 }
                height = window.safeAreaInsets.top
            }
            return height
        }
    }
    
    // 底部安全距离高度
    static var safeDistanceBottomHeight: CGFloat {
        get {
            var height:CGFloat = 0.0
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                guard let windowScene = scene as? UIWindowScene else { return 0 }
                guard let window = windowScene.windows.first else { return 0 }
                height = window.safeAreaInsets.bottom
            } else {
                guard let window = UIApplication.shared.windows.first else { return 0 }
                height = window.safeAreaInsets.bottom
            }
            return height
        }
    }
    
    static var topHeight: CGFloat {
        get {
            
            return safeDistanceTopHeight + NavigationBarHeight
        }
    }
}
