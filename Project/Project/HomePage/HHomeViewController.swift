//
//  HHomeViewController.swift
//  Project
//
//  Created by 胡永亮 on 2023/7/24.
//

import UIKit

class HHomeViewController: HBaseViewController {
    
    var dataSource: [PageConfig] = []
    
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: ScreenWidth, height: ScreenWidth)), style: .plain)
        view.delegate = self
        view.dataSource = self
        view.register(HHomeSubViewCell.self, forCellReuseIdentifier: "HHomeSubViewCell")
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "首页"
        dataSource = HConfig.loadConfigControllers("homePages")

        view.addSubview(tableView)
        tableView.reloadData()
        HHUD.showStatus(status: .successed)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        parent?.tabBarController?.tabBar.changeTabBar(hidden: true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parent?.tabBarController?.tabBar.changeTabBar(hidden: false, animated: true)
    }

}

extension HHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HHomeSubViewCell", for: indexPath)
        if indexPath.row < dataSource.count {
            let item = dataSource[indexPath.row]
            
            cell.textLabel?.text = item.titleName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < dataSource.count {
            let item = dataSource[indexPath.row]
            
            let vc = item.controllerName
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
