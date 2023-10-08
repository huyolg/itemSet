//
//  DoodingBoardController.swift
//  Project
//
//  Created by 胡某人 on 2023/10/8.
//

import UIKit

class DoodlingBoardController: HBaseViewController {

    var doodlingBoard: DoodlingBoardView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Dooding"
        backView()
        
        setUp()
    }
    
    func setUp() {
        let topH = HDevice.topHeight
        let boardHeight = ScreenHeight - HDevice.safeDistanceBottomHeight - topH - 60
        doodlingBoard = DoodlingBoardView(frame: CGRect(origin: CGPoint(x: 0, y: topH), size: CGSize(width: ScreenWidth, height: boardHeight)))
        view.addSubview(doodlingBoard!)
        
        let bottomView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: ScreenHeight - 60 - HDevice.safeDistanceBottomHeight), size: CGSize(width: ScreenWidth, height: 60)))
        bottomView.backgroundColor = UIColor.orange
        
        let item_width = 32.0
        let space_width = (ScreenWidth - item_width * 3) / 4
        let item_top = 14.0
        
        let undoBtn = UIButton(type: .custom)
        undoBtn.setImage(UIImage(named: "undo"), for: .normal)
        undoBtn.frame = CGRect(origin: CGPoint(x: space_width, y: item_top), size: CGSize(width: item_width, height: item_width))
        undoBtn.addTarget(self, action: #selector(tapUndo), for: .touchUpInside)
        bottomView.addSubview(undoBtn)
        undoBtn.isEnabled = false
        
        let redoBtn = UIButton(type: .custom)
        redoBtn.setImage(UIImage(named: "redo"), for: .normal)
        redoBtn.frame = CGRect(origin: CGPoint(x: space_width * 2 + item_width, y: item_top), size: CGSize(width: item_width, height: item_width))
        redoBtn.addTarget(self, action: #selector(tapRedo), for: .touchUpInside)
        bottomView.addSubview(redoBtn)
        redoBtn.isEnabled = false
        
        let clearBtn = UIButton(type: .custom)
        clearBtn.setImage(UIImage(named: "clear"), for: .normal)
        clearBtn.frame = CGRect(origin: CGPoint(x: space_width * 3 + item_width, y: item_top), size: CGSize(width: item_width, height: item_width))
        clearBtn.addTarget(self, action: #selector(tapClear), for: .touchUpInside)
        bottomView.addSubview(clearBtn)
        clearBtn.isEnabled = false
        
        view.addSubview(bottomView)
        
        doodlingBoard?.contentsChangeHandler = {[weak self] hasContents in
            print(hasContents)
            redoBtn.isEnabled = self?.doodlingBoard?.hasUndo ?? false
            undoBtn.isEnabled = hasContents
            clearBtn.isEnabled = self?.doodlingBoard?.hasPaths ?? false
        }
    }
    
    @objc func tapUndo() {
        doodlingBoard?.undo()
    }
    @objc func tapRedo() {
        doodlingBoard?.redo()
    }
    @objc func tapClear() {
        doodlingBoard?.clear()
    }
}
