//
//  HPlaybackManager.swift
//  Project
//
//  Created by 胡某人 on 2023/7/27.
//

import UIKit
import AVFAudio

class HPlaybackManager: NSObject {
    lazy var speechSynthesizer: AVSpeechSynthesizer = {
        let speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self
        return speechSynthesizer
    }()
    func speakSomething(_ msg: String) {
        if msg.isEmpty { return }
        if speechSynthesizer.isSpeaking {
            stopSpeaking()
        }
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let utterance = AVSpeechUtterance(string: msg)
            utterance.rate = 0.54
            utterance.pitchMultiplier = 0.85
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            
            speechSynthesizer.speak(utterance)
        } catch {
            print(error)
        }
    }
    
    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
}

extension HPlaybackManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        
    }
}
