//
//  HBaseViewController.swift
//  Project
//
//  Created by 胡某人 on 2023/7/25.
//

import UIKit

class HBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.init(white: 1, alpha: 1)
        appearance.shadowColor = .clear///下划线颜色
        appearance.backgroundEffect = nil////如果要设置背景透明，这句话非常重要
        appearance.titleTextAttributes = [.foregroundColor:UIColor.black,.font:UIFont.systemFont(ofSize: 18)]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    

    func backView() {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.bounds = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
                
        btn.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: btn)
        
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func tapBack() {
        navigationController?.popViewController(animated: true)
    }

    deinit {
        print("\(self) dealloc")
    }
}
