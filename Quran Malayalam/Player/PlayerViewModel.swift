//
//  PlayerViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 11/01/22.
//

import Foundation
import AVKit

class PlayerViewModel:ObservableObject {
    //MARK: publisher
    @Published private var model = PlayingModel(name: "Surah AlFathiha",
                                     durationInSec: 98,
                                     streamUrl: "https://archive.org/download/malayalam-meal/000_Al_Fattiha.mp3",
                                     downloadUrl: "",
                                     isPlaying: false)
    @Published var isBuffering:Bool = false
    
    private var player:AVPlayer?
    

    //MARK: Stored Properties
    var isPlaying:Bool {model.isPlaying}
    var chapterName:String {model.name}
    var sliderCurrentValue:CGFloat {CMTimeGetSeconds(player?.currentTime() ?? .zero)}
    var sliderMaxValue:CGFloat {CGFloat(model.durationInSec)}
    
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
    
    var durationText:String {
        let totalSeconds = model.durationInSec
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds % 3600 / 60)
        let seconds:Int = Int((totalSeconds % 3600) % 60)
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%i:%02i", minutes, seconds)
        }
    }
    
    init() {setupAudio()}
    
    private func setupAudio() {
        guard let audioUrl = URL(string: model.streamUrl) else {return}
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
        }
    }
    
    
    @objc private func playerDidFinishPlaying(sender: Notification) {
        seekTo(seconds: 0)
        model.isPlaying = false
        player?.pause()
    }
}

//MARK: Play and seek
extension PlayerViewModel {
    func playPause() {
        if model.isPlaying {
            player?.pause()
            model.isPlaying = false
        }else {
            player?.play()
            model.isPlaying = true
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
