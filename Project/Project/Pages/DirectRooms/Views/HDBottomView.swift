//
//  HDBottomView.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

let tag = 10086

enum HActionType {
    case Call, Hangup
}

class HDBottomView: UIView {
    let bag = DisposeBag()
    let actions: [String] = ["call", "hangup"]
    
    var handlerAction: ((_ type: HActionType) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let item_width:CGFloat = 38.0
        let item_top: CGFloat = 10.0
        let margin = (width - item_width * CGFloat(actions.count)) / CGFloat(actions.count + 1)
        for (index,item) in actions.enumerated() {
            let btn = UIButton(type: .custom)
            let _x = item_width * CGFloat(index) + margin * CGFloat(index + 1)
            btn.frame = CGRectMake(_x, item_top, item_width, item_width)
            btn.setImage(UIImage(named: item), for: .normal)
            btn.tag = tag + index
            addSubview(btn)
            btn.rx.tap.bind(onNext: { [weak self] in
                var type: HActionType = .Hangup
                if item == "call" {
                    type = .Call
                }
                self?.handlerAction?(type)
            }).disposed(by: bag)
        }
    }
    
}
