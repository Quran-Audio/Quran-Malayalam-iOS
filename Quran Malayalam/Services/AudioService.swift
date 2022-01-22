//
//  AudioPlayer.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 12/01/22.
//

import Foundation
import AVKit

class AudioService {
    private static let currentChapterKey = "qa-current-chapter"
    private static let baseUrlKey = "qa-base-url"
    static var shared:AudioService = AudioService()
    private init() {}
    private var timer = Timer()
    
    //var onPlayFinished: () -> Void = {}
    //var onBuffering: (Bool) -> Void = { _ in }
    private var isBuffering:Bool = false
    
    
    var currentTimeInSecs:CGFloat {CMTimeGetSeconds(player?.currentTime() ?? .zero)}
    
    var isPlaying:Bool {
        (player?.rate ?? 0) != 0 && player?.error == nil
    }
    
    var currentTimeText:String {
        guard let cmTime = player?.currentTime() else {return "0:00"}
        setIsBuffering()
        
        let totalSeconds = Int(CMTimeGetSeconds(cmTime))
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds % 3600 / 60)
        let seconds:Int = Int((totalSeconds % 3600) % 60)
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%i:%02i", minutes, seconds)
        }
    }
    
    func durationText(secs:Int) -> String {
        let hours:Int = Int(secs / 3600)
        let minutes:Int = Int(secs % 3600 / 60)
        let seconds:Int = Int((secs % 3600) % 60)
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%i:%02i", minutes, seconds)
        }
    }
    
    
    private var player:AVPlayer?
    
    
    func setupAudio() {
        guard let baseUrl = loadBaseUrl(),
              let chapter = loadChapter() else {return}
        guard let audioUrl = URL(string: "\(baseUrl)/\(chapter.fileName)") else {return}
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerEvent), userInfo: nil, repeats: true)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            let item = AVPlayerItem(url: audioUrl)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(sender:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: item)
            player = AVPlayer(playerItem: item)
        } catch {
            print("\(error)")
        }
    }
    
    func setModel(baseUrl:String,model:ChapterModel) {
        saveChapter(model)
        saveBaseUrl(baseUrl)
        setupAudio()
    }
    
    private func setIsBuffering() {
        guard let isPlaybackLikelyToKeepUp = player?.currentItem?.isPlaybackLikelyToKeepUp else {return}
        
        let isBuffering = isPlaybackLikelyToKeepUp == false ? true : false
        if self.isBuffering != isBuffering {
            self.isBuffering = isBuffering
            //onBuffering(isBuffering)
            pushlishBufferingChage()
        }
    }
    
    @objc private func playerDidFinishPlaying(sender: Notification) {
        seekTo(seconds: 0)
        player?.pause()
        pushlishAudioFinished()
    }
    
    func playPause() {
        if isPlaying {
            player?.pause()
        }else {
            player?.play()
        }
    }
    
    func seekTo(seconds:CGFloat) {
        guard let currentTimeScale = self.player?.currentTime().timescale else {return}
        let seekTime = CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTimeScale)
        let isPlaying = self.isPlaying
        
        isPlaying ? player?.pause() : ()
        player?.seek(to: seekTime)
        isPlaying ? player?.play() : ()
    }
    
    @objc private func onTimerEvent() {
        setIsBuffering()
    }
}

//MARK: Save & Load Current Chapter
extension AudioService {
    private func saveBaseUrl(_ baseUrl:String) {
        UserDefaults.standard.set(baseUrl, forKey: AudioService.baseUrlKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadBaseUrl() -> String? {
        return UserDefaults.standard.string(forKey: AudioService.baseUrlKey)
    }
    
    private func saveChapter(_ chapter:ChapterModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(chapter) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: AudioService.currentChapterKey)
            defaults.synchronize()
        }
    }
    
    func loadChapter() -> ChapterModel? {
        guard let chapterData = UserDefaults.standard.object(forKey: AudioService.currentChapterKey) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        if let chapter = try? decoder.decode(ChapterModel.self, from: chapterData) {
            return chapter
        }
        return nil
    }
    
    func isCurrentChapterAvailable() -> Bool {
        return loadChapter() != nil ? true : false
    }
}
//MARK: Notification
extension AudioService {
    struct BufferChangeEvent:Equatable {
        let type = "buffering-changed"
        var isBuffering:Bool
    }
    
    struct AudioFinishedEvent:Equatable {
        let type = "audio-finished"
    }
    private func pushlishBufferingChage() {
        NotificationCenter.default.post(name:.onAudioBufferingChange,
                                        object: BufferChangeEvent(isBuffering: isBuffering),
                                        userInfo: nil)
    }
    
    private func pushlishAudioFinished() {
        NotificationCenter.default.post(name:.onAudioFinished,
                                        object: AudioFinishedEvent(),
                                        userInfo: nil)
    }
}

extension Notification.Name {
    static var onAudioBufferingChange: Notification.Name {
        return .init(rawValue: "Audio.Buffering")
    }
    
    static var onAudioFinished: Notification.Name {
        return .init(rawValue: "Audio.Finished")
    }
}
