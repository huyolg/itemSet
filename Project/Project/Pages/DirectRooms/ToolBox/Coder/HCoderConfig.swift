//
//  HCoderConfig.swift
//  Project
//
//  Created by 胡某人 on 2023/11/8.
//

import UIKit


struct HVideoCoderConfig {
    ///< 可选，系统支持的分辨率，采集分辨率的宽
    var width: Int = 480
    ///< 可选，系统支持的分辨率，采集分辨率的高
    var height: Int = 640
    ///< 自由设置
    var bitrate: Int = 640 * 1000
    ///< 自由设置 25
    var fps: Int = 25
    
}

struct HAudioCoderConfig {
    ///< 码率，默认96000
    var bitrate: Int = 96000
    ///< 声道，默认1
    var channelCount: Int = 1
    ///< 采样点量化，默认16
    var sampleSize: Int = 16
    ///< 采样率，默认44100
    var sampleRate: Int = 44100
    
}
