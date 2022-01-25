//
//  DownloadService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 13/01/22.
//

import UIKit

class DownloadService: NSObject,URLSessionDownloadDelegate {
    private var baseUrl:String? = "https://archive.org/download/malayalam-meal/"
    private var currentChapter:ChapterModel?
    private var downloadList:[ChapterModel] = [ChapterModel(index: 1,
                                                            name: "Chapter 1",
                                                            nameEn: "",
                                                            nameMl: "",
                                                            fileName: "000_Al_Fattiha.mp3",
                                                            size: "",
                                                            durationInSecs: 1),
                                               ChapterModel(index: 112,
                                                            name: "Chapter 112",
                                                            nameEn: "",
                                                            nameMl: "",
                                                            fileName: "112_Al_Ikhlas.mp3",
                                                            size: "",
                                                            durationInSecs: 1),
                                               ChapterModel(index: 113,
                                                            name: "Chapter 113",
                                                            nameEn: "",
                                                            nameMl: "",
                                                            fileName: "113_Al_Falaq.mp3",
                                                            size: "",
                                                            durationInSecs: 1),
                                               ChapterModel(index: 114,
                                                            name: "Chapter 1114",
                                                            nameEn: "",
                                                            nameMl: "",
                                                            fileName: "114_An_Nass.mp3",
                                                            size: "",
                                                            durationInSecs: 1)]
    static var shared = DownloadService()
    private override init() {}
    private var task:URLSessionDownloadTask?
    private var isDownloadingInProgress:Bool = false
    
    
    func startDownload() {
        if task?.state != .running {
            guard let url = URL(string: "https://archive.org/download/malayalam-meal/000_Al_Fattiha.mp3") else {return}
            let session = URLSession(configuration: .default,
                                     delegate: self,
                                     delegateQueue: .main)
            task = session.downloadTask(with: url)
            task?.resume()
            task?.state
        }
    }
    
    
    //FIXME: To Be deleted
    private func startFileDownload(chapter:ChapterModel) {
        guard let baseUrl = baseUrl,
              let url = URL(string: "\(baseUrl)\(chapter.fileName)") else {
            return
        }
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: .main)
        task = session.downloadTask(with: url)
        task?.resume()
        isDownloadingInProgress = true
    }
    
    
    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        moveFrom(source: location)
        publishDownnloadFinished()
        removeFromDownloadQueue(chapter: downloadList.first)
        isDownloadingInProgress = false
        processDownloadQueue()
    }
    
    // MARK: protocol stubs for tracking download progress
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        publishDownloadProgress(progress: progress)
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        publishDownloadStopped()
    }
    
    func moveFrom(source:URL) {
        do {
            let directory = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let destination: URL
            destination = directory
                .appendingPathComponent(source.lastPathComponent)
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: source, to: destination)
        }catch {
            print("File Copy error : \(error.localizedDescription)")
        }
    }
}

//MARK: Notification
extension DownloadService {
    struct DownloadStoppedEvent:Equatable {
        let type = "download-stopped"
    }
    
    struct DownloadFinishedEvent:Equatable {
        let type = "download-finished"
    }
    
    struct DownloadProgressEvent:Equatable {
        let type = "download-proress"
        var progress:CGFloat
        var chapterName:String
    }
    
    
    
    private func publishDownnloadFinished() {
        NotificationCenter.default.post(name:.onDownloadFinished,
                                        object: DownloadFinishedEvent(),
                                        userInfo: nil)
    }
    
    private func publishDownloadProgress(progress:CGFloat) {
        NotificationCenter.default.post(name:.onDownloadProgress,
                                        object: DownloadProgressEvent(progress: progress,
                                                                      chapterName: downloadList.first?.name ?? ""),
                                        userInfo: nil)
    }
    
    private func publishDownloadStopped () {
        NotificationCenter.default.post(name:.onDownloadStopped,
                                        object: DownloadStoppedEvent(),
                                        userInfo: nil)
    }
}

extension Notification.Name {
    static var onDownloadFinished: Notification.Name {
        return .init(rawValue: "Download.Finished")
    }
    
    static var onDownloadProgress: Notification.Name {
        return .init(rawValue: "Download.Progress")
    }
    
    static var onDownloadStopped: Notification.Name {
        return .init(rawValue: "Download.Stopped")
    }
}


//MARK: Download Queue Management
extension DownloadService {
    func setBaseUrl(ulr:String) {
        self.baseUrl = ulr
    }
    
    func addToDownloadQueue(chapter:ChapterModel) {
        if downloadList.firstIndex(of: chapter) == nil {
            downloadList.append(chapter)
        }
    }
    
    func removeFromDownloadQueue(chapter:ChapterModel?) {
        guard let chapter = chapter else {return}

        if let index = downloadList.firstIndex(of: chapter) {
            downloadList.remove(at: index)
        }
    }
    
    func processDownloadQueue() {
        if isDownloadingInProgress {
            if task?.state == .running {
                task?.suspend()            }
            else if task?.state == .suspended {
                task?.resume()
            }
        }else {
            if let chapter = downloadList.first {
                startFileDownload(chapter: chapter)
            }
        }
    }
}
