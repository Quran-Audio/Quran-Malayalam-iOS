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
    @Published var listType:EListType = .all
    var shareText: String {"App to Listen Quran Arabic and malayalam translation\n Url: "}
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {currentChapter?.name ?? ""}
    var sliderCurrentValue: CGFloat{AudioService.shared.currentTimeInSecs}
    var sliderMaxValue: CGFloat{CGFloat(currentChapter?.durationInSecs ?? 0)}
    var currentTimeText:String {AudioService.shared.currentTimeText}
    var durationText:String {AudioService.shared.durationText(secs: currentChapter?.durationInSecs ?? 0)}
    var baseUrl:String?
    
    init() {
        currentChapter = AudioService.shared.loadChapter()
        baseUrl = AudioService.shared.loadBaseUrl()
        AudioService.shared.onPlayFinished = {
            self.currentChapter?.isPlaying = false
        }
        AudioService.shared.onBuffering = { isBuffering in
            self.isBuffering = isBuffering
            print("buffer set")
        }
    }
    
    func reloadCurrenntChapter()  {
        currentChapter = AudioService.shared.loadChapter()
        baseUrl = AudioService.shared.loadBaseUrl()
    }
}

//MARK: Audio
extension PlayerCellViewModel {
    func setCurrent(chapter:ChapterModel) {
        self.currentChapter = chapter
        configureAudio()
        playPause()
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
    
    func configureAudio() {
        guard let baseUrl = baseUrl,
              let chapter = currentChapter else {return}
        AudioService.shared.setModel(baseUrl: baseUrl, model: chapter)
        AudioService.shared.onPlayFinished = {
            self.currentChapter?.isPlaying = false
        }
        AudioService.shared.onBuffering = { isBuffering in
            self.isBuffering = isBuffering
            print("buffer set")
        }
    }
}
