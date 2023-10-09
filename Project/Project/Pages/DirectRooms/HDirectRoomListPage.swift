//
//  HDirectRoomListPage.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit
import RxSwift
import RxCocoa

class HDirectRoomListPage: HBaseViewController {
    let viewModel = HDirectRoomViewModel()
    let bag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(HHomeSubViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge()
        title = "Room Type"
        backView()
        setupTableView()
        viewModel.fetchList()
    }
    
    func setupTableView() {
        view.addSubview(tableView)

        viewModel.dataSource.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: HHomeSubViewCell.self)) {(row, item, cell) in
            if #available(iOS 14.0, *) {
                var cellConfig = cell.defaultContentConfiguration()
                cellConfig.text = item
                cell.contentConfiguration = cellConfig
            } else {
                cell.textLabel?.text = item
            }
        }.disposed(by: bag)
        tableView.rx.modelSelected(String.self).subscribe {[weak self] item in
            let vc = HDirectBroadcastingPage()
            if let name = item.element {
                vc.navigationItem.title = name
            }
            vc.roomType = item.element == "RTC" ? .RTC : .VideoToolBox
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
//            self?.navigationController?.pushViewController(vc, animated: true)
            self?.navigationController?.present(vc, animated: true)
        }.disposed(by: bag)
    }
    

}

extension HDirectRoomListPage {
    
}
