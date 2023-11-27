//
//  HVideoDecoder.swift
//  Project
//
//  Created by 胡某人 on 2023/11/8.
//
//
/**
 视频解码工具
 H264
 */

import UIKit
import CoreVideo.CVPixelBuffer
import VideoToolbox

@objc protocol HVideoDecoderDelegate {
    func videoDecoder(_ videoDecoder: HVideoDecoder, didDecoderSuccess pixelBuffer: CVPixelBuffer)
}

class HVideoDecoder: NSObject {
    private(set) var config: HVideoCoderConfig
    
    var delegate: HVideoDecoderDelegate?
    
    private let decode_queue: DispatchQueue = DispatchQueue(label: "video_decode_queue")
    
    init(config: HVideoCoderConfig) {
        self.config = config
    }
}

extension HVideoDecoder {
    
    /// 视频解码
    /// - Parameter data: H264视频数据
    func videoDecoderH264Data(with data: NSData) {
        // 获取帧二进制数据
        decode_queue.async {[weak self] in
            let u = data.bytes
            self?.decoder(u, with: UInt32(data.length))
        }
        
    }
}

extension HVideoDecoder {
    private func decoder(_ naluData: UnsafeRawPointer, with frameSize: UInt32) {
        // 数据类型:frame，前四个字节为NALU开始码，00 00 00 01
        // 第五位标识数据类型，转化十进制，7表示sps，8表示pps，5表示I帧
//        int type = (naluData[4] & 0x1F);
//        let type = naluData[4] & 0x1F
        // 将NALU的开始码转为4字节大端NALU的长度信息
//        uint32_t naluSize = frameSize - 4;
//        uint8_t *pNaluSize = (uint8_t *)(&naluSize);
//        naluData[0] = *(pNaluSize + 3);
//        naluData[1] = *(pNaluSize + 2);
//        naluData[2] = *(pNaluSize + 1);
//        naluData[3] = *(pNaluSize);
//        CVPixelBufferRef pixelBuffer = NULL;
        
        /**
         第一次解析时: 初始化解码器initDecoder
         判断数据类型，帧数据调用decode:(uint8_t *)frame
         sps/pps数据，则给成员变量赋值保存
         */
//        switch (type) {
//            case 0x05:
//                // 关键帧
//                if ([self initDecoderSession]) {
//                    pixelBuffer = [self decode:naluData withSize:frameSize];
//                }
//                break;
//            case 0x06:
//                // 增强型
//                break;
//            case 0x07:
//                // sps
//                _spsSize = naluSize;
//                _sps = malloc(_spsSize);
//                // 从下标4(也就是第五个元素)开始复制数据
//                memcpy(_sps, &naluData[4], _spsSize);
//                break;
//            case 0x08:
//                // pps
//                _ppsSize = naluSize;
//                _pps = malloc(_ppsSize);
//                // 从下标4(也就是第五个元素)开始复制数据
//                memcpy(_pps, &naluData[4], _ppsSize);
//                break;
//            default:
//                // 其他帧（1-5）
//                if ([self initDecoderSession]) {
//                    pixelBuffer = [self decode:naluData withSize:frameSize];
//                }
//                break;
//        }
    }
//    - (void)decodeNaluData:(uint8_t *)naluData withSize:(uint32_t)frameSize {

}
