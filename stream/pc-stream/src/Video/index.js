import React, { useEffect, useRef } from "react";

const Video = () => {
  const videoRef = useRef(null)
  const canvasRef = useRef(null)

  const onSuccess = (stream) => {
    const video = videoRef.current;
    if ('srcObject' in video) {
      video.srcObject = stream;
    }
    
    video.onloadmetdata = () => {
      console.log("尽量开没");
      video.play()
    }

    // const videoTracks = stream.getVideoTracks();
    // console.log("视频设备: " + videoTracks[0].label);
    // const audioTracks = stream.getAudioTracks();
    // console.log("音频设备: " + audioTracks[0].label);
    // // 播放轨道获取的流
    // videoDOM.srcObject = stream;
    // videoDOM.autoPlay()
  };

  const onError = (error) => console.log(error);

  const openMedia = () => {
    const constraints = {
      audio: true,
      video: {
        width: 600,
        height: 600
      },

    };
    // 访问媒体设备
    navigator.mediaDevices
      .getUserMedia(constraints)
      .then(onSuccess)
      .catch(onError);
  }

  const onCloseMedia = () => {
    const video = videoRef.current;
    const stream = video.srcObject;
    if ('getTracks' in stream) {
      const tracks = stream.getTracks();
      tracks.forEach(track => {
        track.stop()
      });
    }
  }


  return (
    <div>
      <video className="video" ref={videoRef} autoPlay></video>

      <div>
        <button onClick={openMedia}>打开摄像头</button>
        <button onClick={onCloseMedia}>关闭摄像头</button>
      </div>
    </div>
  );
};

export default Video;
