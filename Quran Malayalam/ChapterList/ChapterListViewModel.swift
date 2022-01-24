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
    @Published var listType:EListType = .all
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
        guard let baseUrl = data?.baseUrl,
              let chapter = currentChapter else {return}
        AudioService.shared.setModel(baseUrl: baseUrl, model: chapter)
    }
}

//MARK: Favourite
extension ChapterListViewModel {
    func onFavouriteChapter(chapterIndex:Int) {
        if DataService.shared.isFavourite(index: chapterIndex) {
            DataService.shared.removeFavourite(chapterIndex: chapterIndex)
        }else {
            DataService.shared.setFavourite(index: chapterIndex)
        }
        self.listType = self.listType
    }
}

//MARK: Download
extension ChapterListViewModel {
    func onDownloadChapter(chapter:ChapterModel) {
        if DataService.shared.isDownloaded(index: chapter.index) {
            //FIXME: Delete the chapter mp3 file
            DataService.shared.deleteDownloaded(chapterIndex: chapter.index)
        }else {
            let fullUrl = "\(baseUrl)/\(chapter.fileName)"
            do {
                try DownloadService.shared.startDownload(urlText: fullUrl) { _, _ in
                    DataService.shared.setDownloads(index: chapter.index)
                }
            }catch {
                print("Download failed \(error.localizedDescription)")
            }
        }
        self.listType = self.listType
    }
}

enum EListType {
    case all
    case downloads
    case favourites
}
