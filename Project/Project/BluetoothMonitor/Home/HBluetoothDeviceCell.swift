//
//  HBluetoothDeviceCell.swift
//  Project
//
//  Created by 胡某人 on 2023/7/26.
//

import UIKit
import CoreBluetooth
import SnapKit

class HBluetoothDeviceCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    lazy var macAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    lazy var rssiLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
//    lazy var rssiImgView: UIImageView = {
//        let iconV = UIImageView()
//        return
//    }()
//    
//    lazy var connectedImgView: UIImageView = {
//        let iconV = UIImageView()
//        return
//    }()
    
    
    var item: CBPeripheral? {
        didSet {
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        selectionStyle = .none
        setupSubViews()
    }
    
    func setData() {
        nameLabel.text = item?.name ?? "设备未命名"
        macAddressLabel.text = item?.IEEEAddress
        rssiLabel.text = "\(item?.RSSI ?? -90)"
    }
    
    func setupSubViews() {
        let padding = 12
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(padding)
            make.width.equalTo(ScreenWidth * 0.6)
        }
//        addSubview(connectedImgView)
        addSubview(rssiLabel)
        rssiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-1 * padding)
        }
        let rssiImg = UIImage(named: "signal")
        let rssiImg_w = rssiImg?.size.width ?? 28
        let rssiImg_h = rssiImg?.size.height ?? 28
        let rssiImgView = UIImageView(image: rssiImg)
        addSubview(rssiImgView)
        rssiImgView.snp.makeConstraints { make in
            make.centerY.equalTo(rssiLabel.snp.centerY)
            make.width.equalTo(rssiImg_w * 0.3)
            make.height.equalTo(rssiImg_h * 0.3)
            make.right.equalTo(rssiLabel.snp.left).offset(-8)
        }
        addSubview(macAddressLabel)
        macAddressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.bottom.right.equalToSuperview().offset(-1 * padding)
            make.height.equalTo(24)
        }
    }
    
    
}
