//
//  DownloadCellViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 24/01/22.
//

import Foundation
import CoreGraphics

class DownloadCellViewModel:ObservableObject {
    @Published var progress:CGFloat = 0
    @Published var isDownloading:Bool = false
    
    
    private var model:ChapterModel? = ChapterModel(index: 1, name: "Surah Al Fathiha",
                                                   nameEn: "Surah Al Fathiha",
                                                   nameMl: "Surah Al Fathiha",
                                                   fileName: "000_Al_Fattiha.mp3",
                                                   size: "1mb",
                                                   durationInSecs: 98)
    private var baseUrl:String? = AudioService.shared.loadBaseUrl()
    
    init() {subscribeDownloadNotification()}
    
    func setModel(model:ChapterModel,baseUrl:String) {
        self.baseUrl = baseUrl
        self.model = model
    }
    
    
    func startDownload() {
        isDownloading = true
        DownloadService.shared.startDownload()
    }
    
    private func addToDownloadedList() {
        guard let chapter = model else {return}
        DataService.shared.setDownloads(index: chapter.index)
    }
    
}

//MARK: Notification Handling
extension DownloadCellViewModel {
    @objc func eventsController(_ notification: Notification) {
        guard let event = notification.object else {return}
        switch event {
        case let progressEvent as DownloadService.DownloadProgressEvent:
            progress = progressEvent.progress
            print("Progress \(progress)")
        case _ as DownloadService.DownloadFinishedEvent:
            addToDownloadedList()
            isDownloading = false
            print("Dowwnload Finished")
        case _ as DownloadService.DownloadStoppedEvent:
            isDownloading = false
            print("Dowwnload Stopped")
        default:
            print("===> Unknown")
        }
    }
    
    func subscribeDownloadNotification() {
        unSubscribeDownloadNotification()
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onDownloadFinished,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onDownloadStopped,
                                       object: nil)
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(eventsController(_:)),
                                       name:.onDownloadProgress,
                                       object: nil)
    }
    
    func unSubscribeDownloadNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .onDownloadFinished,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onDownloadStopped,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .onDownloadProgress,
                                                  object: nil)
    }
}

