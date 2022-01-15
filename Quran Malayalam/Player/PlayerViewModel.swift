//
//  PlayerViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 11/01/22.
//

import Foundation
import AVKit

class PlayerViewModel:ObservableObject {
    //MARK: published
    @Published private var model = PlayingModel(name: "Surah AlFathiha",
                                     durationInSec: 98,
                                     streamUrl: "https://archive.org/download/malayalam-meal/000_Al_Fattiha.mp3",
                                     downloadUrl: "",
                                     isPlaying: false)
    @Published var isBuffering:Bool = false
    
    private var player:AVPlayer?
    
    //MARK: Stored Properties
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {model.name}
    var sliderCurrentValue:CGFloat {AudioService.shared.currentTimeInSecs}
    var sliderMaxValue:CGFloat {CGFloat(model.durationInSec)}
    var currentTimeText:String {AudioService.shared.currentTimeText}
    var durationText:String {
        AudioService.shared.durationText(secs: model.durationInSec)
    }
    
    func setModel(model:PlayingModel) {
        self.model = model
        configureAudio()
    }
    
    //MARK: play and seek
    func playPause() {
        AudioService.shared.playPause()
        model.isPlaying = AudioService.shared.isPlaying
    }
    
    func seekTo(seconds:CGFloat) {
        AudioService.shared.seekTo(seconds: seconds)
        model.isPlaying = AudioService.shared.isPlaying
    }
    
    func configureAudio() {
        AudioService.shared.setupAudio(urlText: model.streamUrl)
        AudioService.shared.onPlayFinished = {
            self.model.isPlaying = false
        }
        AudioService.shared.onBuffering = { isBuffering in
            self.isBuffering = isBuffering
        }
    }
    
    func onNext() {
        //FIXME: on next
    }
    
    func onPrevoius() {
        //FIXME: on previus
    }
}
