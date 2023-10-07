//
//  HAudioManager.swift
//  Project
//
//  Created by 胡某人 on 2023/7/27.
//

import UIKit
import AVFAudio

class HAudioManager: NSObject {
    var audioRecorder : AVAudioRecorder? // 录音机
    var audioPlayer : AVAudioPlayer? // 音频播放器
    var setting : [String:Any]? // 录音机的设置
    var audioDir : String? // 录音文件夹路径
    var filename : String? // 记录当前文件名
    var cancelCurrentRecord = false // 取消当前录制
    lazy var timer: Timer = { // 录音声波监控
        let t = Timer(timeInterval: 0.1, target: self, selector: #selector(powerChange), userInfo: nil, repeats: true)
        return t
    }()
    
    //  删除指定后缀的文件
    func removeFileSuffixList(_ suffixList:Array<String>, filePath: String) {
        let fileManager = FileManager.default
        do {
            let contentOfFolder = try fileManager.contentsOfDirectory(atPath: filePath)
        } catch {
            print(error)
        }
    }
//    -(void)removeFileSuffixList:(NSArray<NSString *> *)suffixList filePath:(NSString *)path{
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *contentOfFolder = [fileManager contentsOfDirectoryAtPath:path error:NULL];
//        for (NSString *aPath in contentOfFolder) {
//            NSString * fullPath = [path stringByAppendingPathComponent:aPath];
//            BOOL isDir = NO;if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
//                if (isDir == YES) {
//                    // 是文件夹，则继续遍历
//                    [self removeFileSuffixList:suffixList filePath:fullPath];
//
//                } else{
//                    NSLog(@"file-:%@", aPath);
//                    for (NSString* suffix in suffixList) {
//                        if ([aPath hasSuffix:suffix]) {
//                            if ([fileManager removeItemAtPath:fullPath error:nil]) {
//                                NSLog(@"删除文件成功！！");
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    //  录音声波状态设置
    @objc private func powerChange() {
        audioRecorder?.updateMeters()
        // 更新测量值
        let power = audioRecorder?.averagePower(forChannel: 0) ?? Float(0)
        // 取得第一个通道的音频，注意音频强度范围时-160到0
        _ = power + Float(160.0)
    }
    // 时刻拼接名称
    private func getDateString() -> String {
//        let calendar = Calendar(identifier: .gregorian)
////        let _ = calendar.component(<#T##component: Calendar.Component##Calendar.Component#>, from: <#T##Date#>)
//        let comp:Calendar.Component = .year | .month | .day | .weekday | .hour | .minute | .second
//        let comps = calendar.component(comp , from: Date())
//        let year = comps.year
//        let month = comps.month
//        let day = comps.day
//        let hour = comps.hour
//        let min = comps.minute
//        let sec = comps.second
//        let formatString = "%d%02d%02d%02d%02d%02d"
//        return String.init(format: formatString, year, month, day, hour, min, sec)
        return ""
    }
    
    func stringWithFormat(outFormat:String) -> String {
        let datenow = NSDate()
        let timeSp_now = datenow.timeIntervalSince1970
        
        let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let inputDate = inputFormatter.date(from: "\(timeSp_now)")
        if inputDate == nil{
            return ""
           }
        let outFormatter = DateFormatter()
            outFormatter.dateFormat = outFormat
        let outDateStr = outFormatter.string(from: inputDate!)
           return outDateStr
    }
}

extension HAudioManager:AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    //  录音代理事件
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if cancelCurrentRecord {
            cancelCurrentRecord = false
            print("cancel record")
        } else {
            print("complete record")
        }
    }
    //  播放语音代理事件
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      print("player complete")
    }
}
