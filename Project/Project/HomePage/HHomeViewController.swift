//
//  HHomeViewController.swift
//  Project
//
//  Created by 胡永亮 on 2023/7/24.
//

import UIKit

class HHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "首页"
//        view.backgroundColor = UIColor.blue
        let subView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        subView.backgroundColor = UIColor.red
        view.addSubview(subView)
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
