//
//  DownloadService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 13/01/22.
//

import UIKit

class DownloadService: NSObject,URLSessionDownloadDelegate {
    var currentChapter:ChapterModel? {downloadList.first}
    private var baseUrl:String? = "https://archive.org/download/malayalam-meal/"
    var downloadList:[ChapterModel] = []
    static var shared = DownloadService()
    private override init() {}
    private var task:URLSessionDownloadTask?
    var isDownloadingInProgress:Bool = false
    
    func startDownload() {
        if task?.state != .running {
            guard let url = URL(string: "https://archive.org/download/malayalam-meal/000_Al_Fattiha.mp3") else {return}
            let session = URLSession(configuration: .default,
                                     delegate: self,
                                     delegateQueue: .main)
            task = session.downloadTask(with: url)
            task?.resume()
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
        let chapter = downloadList.first
        moveFrom(source: location,chapter:chapter)
        removeFromDownloadQueue(chapter: chapter)
        isDownloadingInProgress = false
        publishDownnloadFinished(chapterIndex: chapter?.index ?? 0)
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
        processDownloadQueue()
    }
    
    func moveFrom(source:URL,chapter:ChapterModel?) {
        guard let chapter = chapter else {return}

        do {
            let directory = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let destination: URL
            destination = directory
                .appendingPathComponent(chapter.fileName)
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
        let chapterIndex:Int
    }
    
    struct DownloadProgressEvent:Equatable {
        let type = "download-progress"
        var progress:CGFloat
        var chapterName:String
    }
    
    
    
    private func publishDownnloadFinished(chapterIndex:Int) {
        NotificationCenter.default.post(name:.onDownloadFinished,
                                        object: DownloadFinishedEvent(chapterIndex:chapterIndex),
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
                isDownloadingInProgress = true
            }
        }
    }
    
    func cancelCurrentDownload() {
        isDownloadingInProgress = false
        removeFromDownloadQueue(chapter: downloadList.first)
        task?.cancel()
        publishDownloadStopped()
        processDownloadQueue()
    }
}
