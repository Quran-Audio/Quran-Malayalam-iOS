//
//  PlayerCellViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 21/01/22.
//

import Foundation
import CoreGraphics

class PlayerCellViewModel:ObservableObject {
    @Published var currentChapter:ChapterModel?
    @Published var isBuffering:Bool = false
    @Published var sliderValue:CGFloat = 0
    var shareText: String {"App to Listen Quran Arabic and malayalam translation\n Url: "}
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {currentChapter?.name ?? ""}
    var baseUrl:String?
    
    init() {
        subscribeAudioNotification()
        currentChapter = AudioService.shared.loadChapter()
        baseUrl = AudioService.shared.loadBaseUrl()
        isBuffering = AudioService.shared.isBuffering
    }
}

//MARK: play and seek
extension PlayerCellViewModel {
    func playPause() {
        AudioService.shared.playPause()
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
    
    func seekTo(seconds:CGFloat) {
        AudioService.shared.seekTo(seconds: seconds)
        currentChapter?.isPlaying = AudioService.shared.isPlaying
    }
}

//MARK: Notification Handling
extension PlayerCellViewModel {
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
}
