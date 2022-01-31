//
//  AudioPlayer.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 12/01/22.
//

import Foundation
import MediaPlayer
import AVKit

class AudioService {
    private static let currentChapterKey = "qa-current-chapter"
    private static let baseUrlKey = "qa-base-url"
    static var shared:AudioService = AudioService()
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch {
            print("Audio Error:\(error.localizedDescription)")
        }
        setupRemoteTransportControls()
        setupAudio()
    }
    private var timer = Timer()
    
    //var onPlayFinished: () -> Void = {}
    //var onBuffering: (Bool) -> Void = { _ in }
    var isBuffering:Bool = false
    
    
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
        guard let audioUrl = getPlayUrl() else {return}
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
        publishChapterChange()
        setRemoteTrack(chapter: model)
    }
    
    private func setIsBuffering() {
        guard let isPlaybackLikelyToKeepUp = player?.currentItem?.isPlaybackLikelyToKeepUp else {return}
        
        let isBuffering = isPlaybackLikelyToKeepUp == false ? true : false
        if self.isBuffering != isBuffering {
            self.isBuffering = isBuffering
            publishBufferingChage()
        }
    }
    
    @objc private func playerDidFinishPlaying(sender: Notification) {
        seekTo(seconds: 0)
        player?.pause()
        publishAudioFinished()
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
        publishAudioProgress()
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
    
    func getPlayUrl() -> URL? {
        guard let baseUrl = loadBaseUrl(),
                let chapter = loadChapter() else {return nil}
        do {
            let directory = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let localUrl = directory
                .appendingPathComponent(chapter.fileName)
            if FileManager.default.fileExists(atPath: localUrl.path) {
                //Load Local URL
                return localUrl
            }
        }catch {
            print("Error \(error)")
        }
        
        //Load Streaming URL
        return  URL(string: "\(baseUrl)/\(chapter.fileName)")
        
    }
    
    func onNext() {
        guard let currentChapter = loadChapter(),
              currentChapter.index < 114 else {return}
        
        let chapter = DataService.shared.chapterList[currentChapter.index]
        let baseUrl = DataService.shared.baseUrl
        AudioService.shared.setModel(baseUrl: baseUrl, model: chapter)
    }
    
    func onPrevoius() {
        guard let currentChapter = loadChapter(),
              currentChapter.index > 1 else {return}
        
        let chapter = DataService.shared.chapterList[currentChapter.index-2]
        let baseUrl = DataService.shared.baseUrl
        AudioService.shared.setModel(baseUrl: baseUrl, model: chapter)
    }
}
//MARK: Notification
extension AudioService {
    struct BufferChangeEvent:Equatable {
        let type = "buffering-changed"
        var isBuffering:Bool
    }
    
    struct ChapterFinishedEvent:Equatable {
        let type = "audio-finished"
    }
    
    struct PlayProgressEvent:Equatable {
        let type = "audio-proress"
        var progress:CGFloat
    }
    
    struct ChapterChangeEvent:Equatable {
        let type = "audio-chapter-change"
    }
    
    private func publishBufferingChage() {
        NotificationCenter.default.post(name:.onBufferingChange,
                                        object: BufferChangeEvent(isBuffering: isBuffering),
                                        userInfo: nil)
    }
    
    private func publishAudioFinished() {
        NotificationCenter.default.post(name:.onChapterFinished,
                                        object: ChapterFinishedEvent(),
                                        userInfo: nil)
    }
    
    private func publishAudioProgress() {
        guard let chapter = loadChapter() else {return}
        let progress = currentTimeInSecs/CGFloat(chapter.durationInSecs)
        NotificationCenter.default.post(name:.onAudioProgress,
                                        object: PlayProgressEvent(progress: progress),
                                        userInfo: nil)
    }
    
    private func publishChapterChange() {
        NotificationCenter.default.post(name:.onChapterChange,
                                        object: ChapterChangeEvent(),
                                        userInfo: nil)
    }
}

extension Notification.Name {
    static var onBufferingChange: Notification.Name {
        return .init(rawValue: "Audio.Buffering")
    }
    
    static var onChapterFinished: Notification.Name {
        return .init(rawValue: "Audio.Finished")
    }
    
    static var onAudioProgress: Notification.Name {
        return .init(rawValue: "Audio.Progress")
    }
    
    static var onChapterChange: Notification.Name {
        return .init(rawValue: "Audio.ChapterChange")
    }
}

//MARK: Remote Transport Control
extension AudioService {
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            if !self.isPlaying {
                self.playPause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.isPlaying {
                self.playPause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget{ [unowned self] event in
            self.onPrevoius()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget{ [unowned self] event in
            self.onNext()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
            guard let self = self else {return .commandFailed}
            if let player = self.player {
                let playerRate = player.rate
                if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
                    player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
                        guard let self = self else {return}
                        if success {
                            self.player?.rate = playerRate
                        }
                    })
                    return .success
                }
            }
            return .commandFailed
        }
        
        // Register to receive events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
    }
    
    func setRemoteTrack(chapter:ChapterModel) {
        var currentTrack = [String:Any]()
        currentTrack[MPMediaItemPropertyTitle] = chapter.nameEn
        currentTrack[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTimeInSecs
        currentTrack[MPMediaItemPropertyPlaybackDuration] = chapter.durationInSecs / 1000
        currentTrack[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        if let image = UIImage(named: "launch") {
            let artWork:MPMediaItemArtwork = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
            currentTrack[MPMediaItemPropertyArtwork] = artWork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = currentTrack
        
    }
}
