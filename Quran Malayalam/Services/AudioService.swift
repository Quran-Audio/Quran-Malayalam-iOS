//
//  AudioPlayer.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 12/01/22.
//

import Foundation
import AVKit

class AudioService {
    static var shared:AudioService = AudioService()
    private init() {}
    
    var onPlayFinished: () -> Void = {}
    var onBuffering: (Bool) -> Void = { _ in }
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
    
    
    func setupAudio(urlText:String) {
        guard let audioUrl = URL(string: urlText) else {return}
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
    
    private func setIsBuffering() {
        guard let isPlaybackLikelyToKeepUp = player?.currentItem?.isPlaybackLikelyToKeepUp else {return}
        
        let isBuffering = isPlaybackLikelyToKeepUp == false ? true : false
        if self.isBuffering != isBuffering {
            self.isBuffering = isBuffering
            onBuffering(isBuffering)
        }
    }
    
    @objc private func playerDidFinishPlaying(sender: Notification) {
        seekTo(seconds: 0)
        player?.pause()
        onPlayFinished()
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
}
