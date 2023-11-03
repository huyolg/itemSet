/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useRef} from 'react';
import {
  Button,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
} from 'react-native';
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
import DID_API from './api.json';
// import {fetchStreamMsg} from './StreamClient';

import {Colors} from 'react-native/Libraries/NewAppScreen';

const DIDStream = () => {
  let peerConnection;
  let streamId;
  let sessionId;
  let sessionClientAnswer;

  let statsIntervalId;
  let videoIsPlaying;
  let lastBytesReceived;

  useEffect(() => {
    console.log('初始化');
    // loadStreamMsg();
  });

  const loadStreamMsg = async () => {
    const sessionResponse = await fetchWithRetries(
      `${DID_API.url}/talks/streams`,
      {
        method: 'POST',
        headers: {
          Authorization: `Basic ${DID_API.key}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          source_url:
            'https://d-id-public-bucket.s3.amazonaws.com/or-roman.jpg',
        }),
      },
    );
    const {
      id: newStreamId,
      offer,
      ice_servers: iceServers,
      session_id: newSessionId,
    } = await sessionResponse.json();
    streamId = newStreamId;
    sessionId = newSessionId;

    try {
      sessionClientAnswer = await createPeerConnection(offer, iceServers);
    } catch (e) {
      console.log('error during streaming setup', e);
      stopAllStreams();
      closePC();
      return;
    }

    const sdpResponse = await fetch(
      `${DID_API.url}/talks/streams/${streamId}/sdp`,
      {
        method: 'POST',
        headers: {
          Authorization: `Basic ${DID_API.key}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          answer: sessionClientAnswer,
          session_id: sessionId,
        }),
      },
    );
  };

  const createPeerConnection = async (offer, iceServers) => {
    if (!peerConnection) {
      peerConnection = new RTCPeerConnection({iceServers});
      peerConnection.addEventListener(
        'icegatheringstatechange',
        onIceGatheringStateChange,
        true,
      );
      peerConnection.addEventListener('icecandidate', onIceCandidate, true);
      peerConnection.addEventListener(
        'iceconnectionstatechange',
        onIceConnectionStateChange,
        true,
      );
      peerConnection.addEventListener(
        'connectionstatechange',
        onConnectionStateChange,
        true,
      );
      peerConnection.addEventListener(
        'signalingstatechange',
        onSignalingStateChange,
        true,
      );
      peerConnection.addEventListener('track', onTrack, true);
    }

    await peerConnection.setRemoteDescription(offer);
    console.log('set remote sdp OK');

    const sessionClientAnswer = await peerConnection.createAnswer();
    console.log('create local sdp OK');

    await peerConnection.setLocalDescription(sessionClientAnswer);
    console.log('set local sdp OK');

    return sessionClientAnswer;
  };

  const onTrack = event => {
    if (!event.track) return;

    statsIntervalId = setInterval(async () => {
      const stats = await peerConnection.getStats(event.track);
      stats.forEach(report => {
        if (report.type === 'inbound-rtp' && report.mediaType === 'video') {
          const videoStatusChanged =
            videoIsPlaying !== report.bytesReceived > lastBytesReceived;

          if (videoStatusChanged) {
            videoIsPlaying = report.bytesReceived > lastBytesReceived;
            onVideoStatusChange(videoIsPlaying, event.streams[0]);
          }
          lastBytesReceived = report.bytesReceived;
        }
      });
    }, 500);
  };
  const onSignalingStateChange = () => {
    console.log('signalingState-' + peerConnection.signalingState);
  };
  const onConnectionStateChange = () => {
    console.log('peerConnectionState-' + peerConnection.connectionState);
  };
  const onIceConnectionStateChange = () => {
    console.log('iceConnectionState-' + peerConnection.iceConnectionState);
    if (
      peerConnection.iceConnectionState === 'failed' ||
      peerConnection.iceConnectionState === 'closed'
    ) {
      stopAllStreams();
      closePC();
    }
  };
  const onIceCandidate = event => {
    console.log('onIceCandidate', event);
    if (event.candidate) {
      const {candidate, sdpMid, sdpMLineIndex} = event.candidate;

      fetch(`${DID_API.url}/talks/streams/${streamId}/ice`, {
        method: 'POST',
        headers: {
          Authorization: `Basic ${DID_API.key}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          candidate,
          sdpMid,
          sdpMLineIndex,
          session_id: sessionId,
        }),
      });
    }
  };

  const handlerSaySomething = async () => {
    if (
      peerConnection?.signalingState === 'stable' ||
      peerConnection?.iceConnectionState === 'connected'
    ) {
      const talkResponse = await fetchWithRetries(
        `${DID_API.url}/talks/streams/${streamId}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Basic ${DID_API.key}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            script: {
              type: 'audio',
              audio_url:
                'https://d-id-public-bucket.s3.us-west-2.amazonaws.com/webrtc.mp3',
            },
            driver_url: 'bank://lively/',
            config: {
              stitch: true,
            },
            session_id: sessionId,
          }),
        },
      );
    }
  };

  const onIceGatheringStateChange = () => {
    console.log('iceGatheringState-' + peerConnection.iceGatheringState);
  };

  const onVideoStatusChange = (videoIsPlaying, stream) => {
    let status;
    if (videoIsPlaying) {
      status = 'streaming';
      const remoteStream = stream;
      // setVideoElement(remoteStream);
    } else {
      status = 'empty';
      // playIdleVideo();
    }
    console.log('streamingState-' + status);
  };

  const stopAllStreams = () => {};
  const closePC = (pc = peerConnection) => {
    if (!pc) return;
    console.log('stopping peer connection');
    pc.close();
    pc.removeEventListener(
      'icegatheringstatechange',
      onIceGatheringStateChange,
      true,
    );
    pc.removeEventListener('icecandidate', onIceCandidate, true);
    pc.removeEventListener(
      'iceconnectionstatechange',
      onIceConnectionStateChange,
      true,
    );
    pc.removeEventListener(
      'connectionstatechange',
      onConnectionStateChange,
      true,
    );
    pc.removeEventListener(
      'signalingstatechange',
      onSignalingStateChange,
      true,
    );
    pc.removeEventListener('track', onTrack, true);
    clearInterval(statsIntervalId);
    // iceGatheringStatusLabel.innerText = '';
    // signalingStatusLabel.innerText = '';
    // iceStatusLabel.innerText = '';
    // peerStatusLabel.innerText = '';
    console.log('stopped peer connection');
    if (pc === peerConnection) {
      peerConnection = null;
    }
  };
  const maxRetryCount = 3;
  const maxDelaySec = 4;

  const fetchWithRetries = async (url, options, retries = 1) => {
    console.log('地址 = , url', url);
    try {
      return await fetch(url, options);
    } catch (err) {
      if (retries <= maxRetryCount) {
        const delay =
          Math.min(Math.pow(2, retries) / 4 + Math.random(), maxDelaySec) *
          1000;

        await new Promise(resolve => setTimeout(resolve, delay));

        console.log(
          `Request failed, retrying ${retries}/${maxRetryCount}. Error ${err}`,
        );
        return fetchWithRetries(url, options, retries + 1);
      } else {
        throw new Error(`Max retries exceeded. error: ${err}`);
      }
    }
  };
  return (
    <SafeAreaView>
      <StatusBar />
      <View>
        <Text> - ye-mian -</Text>
        <View>
          {/* <video src="https://vd2.bdstatic.com/mda-pijcqmi985htkw4d/720p/h264/1695200420512383206/mda-pijcqmi985htkw4d.mp4?v_from_s=hkapp-haokan-nanjing&auth_key=1699004905-0-0-f2b0bdc6040f4d42c92fa3ad76a4170a&bcevod_channel=searchbox_feed&pd=1&cr=2&cd=0&pt=3&logid=2905192542&vid=5153764234588161376&klogid=2905192542&abtest=114032_1-114240_1" /> */}

          {/* <Button onPress={handlerSaySomething}>Say something</Button> */}
        </View>
      </View>
    </SafeAreaView>
  );
};

export default DIDStream;
