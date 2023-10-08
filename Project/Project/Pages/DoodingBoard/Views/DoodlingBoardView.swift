//
//  DoodingBoardView.swift
//  Project
//
//  Created by 胡某人 on 2023/10/8.
//

import UIKit

class DoodlingPath: UIBezierPath {
    var hex: UInt = 0x000000
    var points: [[String: CGFloat]] = []
    var info: [String: Any] {
        get {
            var dict: [String: Any] = [:]
            dict["color"] = hex
            dict["points"] = points
            return dict
        }
    }
    var strokeColor: UIColor {
        get {
            return UIColor(hex)
        }
    }
}

class DoodlingBoardView: UIView {
    public var hex:UInt = 0x000000
    public var strokeColor: UIColor {
        get {
            return UIColor(hex)
        }
    }
    public var lineWidth: CGFloat = 18.0
    
    public var hasContents: Bool {
        get {
            return paths.count > 0
        }
    }
    
    public var hasUndo: Bool {
        get {
            return undoPaths.count > 0
        }
    }
    
    public var contents: [[String: Any]] {
        get {
            guard hasContents else {
                return []
            }
            let pathInfos = paths.map {$0.info}
            return pathInfos
        }
    }
    public var hasPaths: Bool {
        get {
            return undoPaths.count > 0 || paths.count > 0
        }
    }
    public var contentsChangeHandler: ((_ hasContents: Bool) -> ())?
    
    private var paths: [DoodlingPath] = []
    private var path = DoodlingPath()
    private var undoPath: DoodlingPath?
    private var undoPaths: [DoodlingPath] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        let ges = UIPanGestureRecognizer(target: self, action: #selector(panges(_:)))
        ges.maximumNumberOfTouches = 1
        addGestureRecognizer(ges)
    }
    deinit {
        print("doodling board dealloc")
    }
}

extension DoodlingBoardView {
    @objc private func panges(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        if sender.state == .began {
            path = DoodlingPath()
            path.lineWidth = lineWidth
            path.hex = hex
            path.move(to: point)
            path.points.append(["x": point.x, "y": point.y])
            paths.append(path)
            contentsChangeHandler?(hasContents)
        }
        path.addLine(to: point)
        path.points.append(["x": point.x, "y": point.y])
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        paths.forEach {
            $0.strokeColor.set()
            $0.stroke()
        }
    }
}

extension DoodlingBoardView {
    func undo() {
        guard paths.count > 0 else {
            return
        }
        let path = paths.removeLast()
        undoPaths.append(path)
        setNeedsDisplay()
        contentsChangeHandler?(hasContents)
    }
    
    func redo() {
//        guard undoPaths.count > 0 else {
//            return
//        }
        let path = undoPaths.removeLast()
        paths.append(path)
        setNeedsDisplay()
        undoPath = nil
        contentsChangeHandler?(hasContents)
    }
    
    func clear() {
        paths.removeAll()
        undoPaths.removeAll()
        undoPath = nil
        setNeedsDisplay()
        contentsChangeHandler?(hasContents)
    }
    
    func snap() -> UIImage? {
        layer.backgroundColor = UIColor.black.cgColor
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        layer.backgroundColor = UIColor.clear.cgColor
        return image
    }

}
