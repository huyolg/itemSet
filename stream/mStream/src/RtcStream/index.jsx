import React, {useEffect, useState} from 'react';
import {View} from 'react-native';
import {
  ScreenCapturePickerView,
  RTCPeerConnection,
  RTCIceCandidate,
  RTCSessionDescription,
  RTCView,
  MediaStream,
  MediaStreamTrack,
  mediaDevices,
} from 'react-native-webrtc';

const RtcStream = () => {
  // var local_stream = null;
  // var remote_stream = null;
  const [local_stream, setLocal_stream] = useState(null);
  // const [remote_stream, setRemote_stream] = useState(null);
  // 1. 创建实例
  let peer = new RTCPeerConnection();

  useEffect(() => {
    getMedia();
  });

  // 3. 接收远程视频流
  peer.ontrack = async event => {
    let [remoteStream] = event.streams;
    // let remote_stream = remoteStream;
    // setRemote_stream(remoteStream);
  };

  // 获取本地摄像头
  const getMedia = async () => {
    let localStream = await mediaDevices.getUserMedia({
      audio: true,
      video: true,
    });
    // console.log('本地留', localStream);
    setLocal_stream(localStream);
    // 2. 将本地视频流添加到实例中
    localStream.getTracks().forEach(track => {
      peer.addTrack(track, localStream);
    });
  };

  // 播放视频组件
  const Player = () => {
    return (
      <View>
        <RTCView
          style={{height: 500}}
          streamURL={local_stream && local_stream.toURL()}
        />
        {/* <RTCView style={{height: 500}} streamURL={remote_stream.toURL()} /> */}
      </View>
    );
  };

  return (
    <View>
      {Player()}
      <View></View>
    </View>
  );
};

export default RtcStream;
