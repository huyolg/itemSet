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
        appearance.backgroundColor = UIColor.lightGray
        appearance.shadowColor = .clear///下划线颜色
        appearance.backgroundEffect = nil////如果要设置背景透明，这句话非常重要
        appearance.titleTextAttributes = [.foregroundColor:UIColor.blue,.font:UIFont.systemFont(ofSize: 18)]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
