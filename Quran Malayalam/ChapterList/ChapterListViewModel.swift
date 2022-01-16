//
//  ChapterListViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import Combine
import Foundation
import CoreGraphics

class ChapterListViewModel: ObservableObject {
    @Published var currentChapter:ChapterModel?
    @Published var isBuffering:Bool = false
    var listType:EListType = .all
    var shareText: String {"App to Listen Quran Arabic and malayalam translation\n Url: "}
    var isPlaying:Bool {AudioService.shared.isPlaying}
    var chapterName:String {currentChapter?.name ?? ""}
    var sliderCurrentValue: CGFloat{AudioService.shared.currentTimeInSecs}
    var sliderMaxValue: CGFloat{CGFloat(currentChapter?.durationInSecs ?? 0)}
    var currentTimeText:String {AudioService.shared.currentTimeText}
    var durationText:String {AudioService.shared.durationText(secs: currentChapter?.durationInSecs ?? 0)}
    var baseUrl:String {data?.baseUrl ?? ""}
    
    
    
    var chapters:[ChapterModel] {
        switch listType {
        case .all:
            return data?.chapters ?? []
        case .downloads:
            let downloads = DataService.shared.getDownloads()
            return data?.chapters.filter({ chapter in
                downloads.contains(chapter.index)
            }) ?? []
        case .favourites:
            let favourites = DataService.shared.getFavourites()
            return data?.chapters.filter({ chapter in
                favourites.contains(chapter.index)
            }) ?? []
        }
    }
        

    
    private var data:DataModel?
    init() {
        self.data = DataService.shared.loadData()
    }
}

//MARK: Audio
extension ChapterListViewModel {
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
        AudioService.shared.setupAudio(urlText: "\(data?.baseUrl ?? "")/\(currentChapter?.fileName ?? "")")
        AudioService.shared.onPlayFinished = {
            self.currentChapter?.isPlaying = false
        }
        AudioService.shared.onBuffering = { isBuffering in
            self.isBuffering = isBuffering
            print("buffer set")
        }
    }
}

enum EListType {
    case all
    case downloads
    case favourites
}
