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
    @Published var currentChapter:ChapterModel?
    @Published var isBuffering:Bool = false
    @Published var sliderValue:CGFloat = 0
    
    private var player:AVPlayer?
    private var baseUrl:String?
    
    //MARK: Stored Properties
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {currentChapter?.name ?? ""}
    var sliderCurrentValue:CGFloat {AudioService.shared.currentTimeInSecs}
    var sliderMaxValue:CGFloat {CGFloat(currentChapter?.durationInSecs ?? 0)}
    var currentTimeText:String {AudioService.shared.currentTimeText}
    var durationText:String {
        AudioService.shared.durationText(secs: currentChapter?.durationInSecs ?? 0)
    }
    
    init() {
        currentChapter = AudioService.shared.loadChapter()
        baseUrl = AudioService.shared.loadBaseUrl()
        isBuffering = AudioService.shared.isBuffering
    }
    
    //MARK: play and seek
    func playPause() {
        AudioService.shared.playPause()
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
    
    func seekTo(seconds:CGFloat) {
        AudioService.shared.seekTo(seconds: seconds)
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
    
    func onNext() {
        //FIXME: on next
    }
    
    func onPrevoius() {
        //FIXME: on previus
    }
}

//MARK: Notification Handling
extension PlayerViewModel {
    func subscribeAudioNotification() {
        unSubscribeAudioNotification()
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onAudioProgress,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onAudioBufferingChange,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onAudioFinished,
                                       object: nil)
    }
    
    func unSubscribeAudioNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .onAudioProgress,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onAudioFinished,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onAudioBufferingChange,
                                                  object: nil)
    }
    
    @objc func eventsController(_ notification: Notification) {
        guard let event = notification.object else {return}
        switch event {
        case let progressEvent as AudioService.AudioProgressEvent:
            sliderValue = progressEvent.progress
        case let bufferEvent as AudioService.BufferChangeEvent:
            self.isBuffering = bufferEvent.isBuffering
        case _ as AudioService.AudioFinishedEvent:
            self.currentChapter?.isPlaying = false
            
        default:
            print("===> Unknown")
        }
    }
    
    func updateUI() {
        
    }
}
