//
//  HDirectBroadcastingPage.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit

class HDirectBroadcastingPage: HBaseViewController {
    public var roomType: HBroadcastingType?
    private var bottomView: UIView?
    private var roomView: HBroadcastingRoomView?

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge()
        
        
        setup()
        bottomView = bottomControlView()
        view.bringSubviewToFront(bottomView!)
        backView()
    }
    
    func setup() {
        if let type = roomType {
            roomView = HBroadcastingFactory.factory(type) as? HBroadcastingRoomView
            view.addSubview(roomView!)
            roomView?.frame = CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: ScreenHeight))
            loadViewIfNeeded()
        }
    }
    
    func bottomControlView() -> UIView {
        let bottom = HDBottomView(frame: CGRect(origin: CGPoint(x: 0, y: ScreenHeight - 60 - HDevice.safeDistanceBottomHeight), size: CGSize(width: ScreenWidth, height: ScreenHeight)))
        view.addSubview(bottom)
        bottom.backgroundColor = .clear
        bottom.handlerAction = {[weak self] type in
            switch type {
            case .Call:
                self?.roomView?.call()
            case .Hangup:
                self?.roomView?.hangup()
                self?.tapBack()
            }
        }
        return bottom
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bottomView?.alpha == 0 {
            bottomView?.alpha = 1
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.bottomView?.frame = CGRect(origin: CGPoint(x: 0, y: ScreenHeight - 60 - HDevice.safeDistanceBottomHeight), size: CGSize(width: ScreenWidth, height: ScreenHeight))
            }
        } else {
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.bottomView?.frame = CGRect(origin: CGPoint(x: 0, y: ScreenHeight), size: CGSize(width: ScreenWidth, height: ScreenHeight))
                self?.bottomView?.alpha = 0
            }
        }
    }
    
    override func backView() {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.frame = CGRect(x: 24, y: HDevice.safeDistanceTopHeight, width: 44, height: 44)
        view.addSubview(btn)
        btn.layer.cornerRadius = 22
        btn.backgroundColor = UIColor(white: 1, alpha: 0.5)
        btn.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
    }
    
    override func tapBack() {
        dismiss(animated: true)
    }
    
    

}
