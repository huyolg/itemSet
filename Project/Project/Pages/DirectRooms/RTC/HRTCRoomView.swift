//
//  HRTCRoomView.swift
//  Project
//
//  Created by 胡某人 on 2023/10/9.
//

import UIKit
import SnapKit
import WebRTC

class HRTCRoomView: HBroadcastingRoomView {
    private let AUDIO_TRACK_ID = "ARDAMSa0"
    private let VIDEO_TRACK_ID = "ARDAMSv0"
    private let STREAM_IDS = ["ARDAMS"]
    private let WIDTH = 1280
    private let HEIGHT = 720
    private let FPS = 30
    
    private var localView: RTCEAGLVideoView!
    private var remoteView: RTCEAGLVideoView!
    private var peerConnectionFactory: RTCPeerConnectionFactory!
    private var audioTrack: RTCAudioTrack?
    private var videoTrack: RTCVideoTrack?
    /**
     iOS 需要将 Capturer 保存为全局变量，否则无法渲染本地画面
     */
    private var videoCapturer: RTCVideoCapturer?
    /**
     iOS 需要将远端流保存为全局变量，否则无法渲染远端画面
     */
    private var remoteStream: RTCMediaStream?
    private var localPeerConnection: RTCPeerConnection?
    private var remotePeerConnection: RTCPeerConnection?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    接通
    override func call() {
        // 创建 PeerConnection
        let rtcConfiguration = RTCConfiguration()
        var mandatoryConstraints : [String : String] = [:]
        var optionalConstraints : [String : String] = [:]
        var mediaConstraints = RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: optionalConstraints)
        localPeerConnection = peerConnectionFactory.peerConnection(with: rtcConfiguration, constraints: mediaConstraints, delegate: self)
        // 为 PeerConnection 添加音轨、视轨
        localPeerConnection?.add(audioTrack!, streamIds: STREAM_IDS)
        localPeerConnection?.add(videoTrack!, streamIds: STREAM_IDS)
        // 通过 PeerConnection 创建 offer，获取 sdp
        mandatoryConstraints = [:]
        optionalConstraints = [:]
        mediaConstraints = RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: optionalConstraints)
        localPeerConnection?.offer(for: mediaConstraints, completionHandler: { sessionDescription, error in
            print("create offer success.")
            print(sessionDescription)
            // 将 offer sdp 作为参数 setLocalDescription
            self.localPeerConnection?.setLocalDescription(sessionDescription!, completionHandler: { _ in
                print("set local sdp success.")
                // 发送 offer sdp
                self.sendOffer(offer: sessionDescription!)
            })
        })
    }
    //    中断
    override func pause() {
        (videoCapturer as? RTCCameraVideoCapturer)?.stopCapture()
        videoCapturer = nil
        localPeerConnection?.close()
        localPeerConnection = nil
        remotePeerConnection?.close()
        remotePeerConnection = nil
    }
    
    override func hangup() {
        // 关闭 PeerConnection
        localPeerConnection?.close()
        localPeerConnection = nil
        
        remotePeerConnection?.close()
        remotePeerConnection = nil
        // 释放远端视频渲染控件
        if let track = remoteStream?.videoTracks.first {
            track.remove(remoteView!)
        }
    }
    
}

extension HRTCRoomView {
    
    func setup() {
        // 初始化 PeerConnectionFactory
        initPeerConnectionFactory()
        // 创建 EglBase
        // 创建 PeerConnectionFactory
        peerConnectionFactory = createPeerConnectionFactory()
        // 创建音轨
        audioTrack = createAudioTrack(peerConnectionFactory: peerConnectionFactory)
        // 创建视轨
        videoTrack = createVideoTrack(peerConnectionFactory: peerConnectionFactory)
        let tuple = createVideoCapturer(videoSource: videoTrack!.source)
        let captureDevice = tuple.captureDevice
        videoCapturer = tuple.videoCapture
        // 初始化本地视频渲染控件
        localView = RTCEAGLVideoView()
        localView.delegate = self
        insertSubview(localView,at: 0)
        localView.snp.makeConstraints({ maker in
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
            maker.centerY.equalToSuperview()
        })
        videoTrack?.add(localView!)
        // 初始化远端视频渲染控件
        remoteView = RTCEAGLVideoView()
        remoteView.delegate = self
        insertSubview(remoteView, aboveSubview: localView)
        remoteView.snp.makeConstraints({ maker in
            maker.width.equalTo(90)
            maker.height.equalTo(160)
            maker.top.equalToSuperview().offset(30)
            maker.right.equalToSuperview().offset(-30)
        })
        // 开始本地渲染
        (videoCapturer as? RTCCameraVideoCapturer)?.startCapture(with: captureDevice!, format: captureDevice!.activeFormat, fps: FPS)
    }
    
    private func initPeerConnectionFactory() {
        RTCPeerConnectionFactory.initialize()
    }
    
    private func createPeerConnectionFactory() -> RTCPeerConnectionFactory {
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
//        if TARGET_OS_SIMULATOR != 0 {
//            videoEncoderFactory = RTCSimluatorVideoEncoderFactory()
//            videoDecoderFactory = RTCSimulatorVideoDecoderFactory()
//        }
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }
    
    private func createAudioTrack(peerConnectionFactory: RTCPeerConnectionFactory) -> RTCAudioTrack {
        let mandatoryConstraints : [String : String] = [:]
        let optionalConstraints : [String : String] = [:]
        let audioSource = peerConnectionFactory.audioSource(with: RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: optionalConstraints))
        let audioTrack = peerConnectionFactory.audioTrack(with: audioSource, trackId: AUDIO_TRACK_ID)
        audioTrack.isEnabled = true
        return audioTrack
    }
    
    private func createVideoTrack(peerConnectionFactory: RTCPeerConnectionFactory) -> RTCVideoTrack? {
        let videoSource = peerConnectionFactory.videoSource()
        let videoTrack = peerConnectionFactory.videoTrack(with: videoSource, trackId: VIDEO_TRACK_ID)
        videoTrack.isEnabled = true
        return videoTrack
    }
    
    private func createVideoCapturer(videoSource: RTCVideoSource) -> (captureDevice: AVCaptureDevice?, videoCapture: RTCVideoCapturer?) {
        let videoCapturer = RTCCameraVideoCapturer(delegate: videoSource)
        let captureDevices = RTCCameraVideoCapturer.captureDevices()
        if (captureDevices.count == 0) {
            return (nil, nil)
        }
        var captureDevice: AVCaptureDevice?
        for c in captureDevices {
            // 前摄像头
            if (c.position == .front) {
                captureDevice = c
                break
            }
        }
        if (captureDevice == nil) {
            return (nil, nil)
        }
        return (captureDevice, videoCapturer)
    }

    
    private func sendOffer(offer: RTCSessionDescription) {
        receivedOffer(offer: offer)
    }
    
    private func receivedOffer(offer: RTCSessionDescription) {
        // 创建 PeerConnection
        let rtcConfiguration = RTCConfiguration()
        let mandatoryConstraints : [String : String] = [:]
        let optionalConstraints : [String : String] = [:]
        let mediaConstraints = RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: optionalConstraints)
        remotePeerConnection = peerConnectionFactory.peerConnection(with: rtcConfiguration, constraints: mediaConstraints, delegate: self)
        // 将 offer sdp 作为参数 setRemoteDescription
        remotePeerConnection?.setRemoteDescription(offer, completionHandler: { _ in
            print("set remote sdp success.")
            // 通过 PeerConnection 创建 answer，获取 sdp
            let mandatoryConstraints : [String : String] = [:]
            let optionalConstraints : [String : String] = [:]
            let mediaConstraints = RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints, optionalConstraints: optionalConstraints)
            self.remotePeerConnection?.answer(for: mediaConstraints, completionHandler: { sessionDescription, error in
                print("create answer success.")
                // 将 answer sdp 作为参数 setLocalDescription
                self.remotePeerConnection?.setLocalDescription(sessionDescription!, completionHandler: { _ in
                    print("set local sdp success.")
                    // 发送 answer sdp
                    self.sendAnswer(answer: sessionDescription!)
                })
            })
        })
    }
    
    private func sendAnswer(answer: RTCSessionDescription) {
        receivedAnswer(answer: answer)
    }
    
    private func receivedAnswer(answer: RTCSessionDescription) {
        print("receivedAnswer")
        // 收到 answer sdp，将 answer sdp 作为参数 setRemoteDescription
        localPeerConnection?.setRemoteDescription(answer, completionHandler: { _ in   print("set remote sdp success.")
        })
    }
    
    private func sendIceCandidate(peerConnection: RTCPeerConnection, iceCandidate: RTCIceCandidate)  {
        receivedCandidate(peerConnection: peerConnection,iceCandidate: iceCandidate)
    }
    
    private func receivedCandidate(peerConnection: RTCPeerConnection, iceCandidate: RTCIceCandidate) {
        print("receivedCandidate = \(peerConnection == localPeerConnection)")
        if (peerConnection == localPeerConnection) {
            remotePeerConnection?.add(iceCandidate)
        } else {
            localPeerConnection?.add(iceCandidate)
        }
    }
}


// MARK: - RTCVideoViewDelegate
extension HRTCRoomView: RTCVideoViewDelegate {
   func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
   }
}

// MARK: - RTCPeerConnectionDelegate
extension HRTCRoomView: RTCPeerConnectionDelegate {
   func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
       print("peerConnection didAdd stream--->\(stream)")
       if (peerConnection == self.localPeerConnection) {
       } else if (peerConnection == self.remotePeerConnection) {
           self.remoteStream = stream
           if let track = stream.videoTracks.first {
               track.add(remoteView!)
           }
           if let audioTrack = stream.audioTracks.first{
               audioTrack.source.volume = 8
           }
       }
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
   }
   
   func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
       print("didGenerate candidate--->\(candidate)")
       self.sendIceCandidate(peerConnection: peerConnection, iceCandidate: candidate)
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
   }
   
   func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
   }
}

