//
//  DownloadService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 13/01/22.
//

import UIKit

class DownloadService: NSObject,URLSessionDownloadDelegate {
    static var shared = DownloadService()
    private override init() {}
    private var task:URLSessionDownloadTask?
    
    
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
    
    
    func startDownload(urlText:String, completion: @escaping (URL?, Error?) -> Void) throws {
//        guard let url = URL(string: urlText) else {return}
//
//        let directory = try FileManager.default.url(for: .documentDirectory,
//                                                       in: .userDomainMask,
//                                                       appropriateFor: nil,
//                                                       create: true)
//        let destination: URL
//        destination = directory
//            .appendingPathComponent(url.lastPathComponent)
//        let session = URLSession(configuration: .default,
//                                 delegate: self,
//                                 delegateQueue: .main)
//
//        session.downloadTask(with: url) { location, _, error in
//            guard let location = location else {
//                completion(nil, error)
//                return
//            }
//            do {
//                if FileManager.default.fileExists(atPath: destination.path) {
//                    try FileManager.default.removeItem(at: destination)
//                }
//                try FileManager.default.moveItem(at: location, to: destination)
//                completion(destination, nil)
//            } catch {
//                print(error)
//            }
//        }.resume()
    }
    
    
    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        moveFrom(source: location)
        publishDownnloadFinished()
        print("download completion")
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
    }
    
    
    
    private func publishDownnloadFinished() {
        NotificationCenter.default.post(name:.onDownloadFinished,
                                        object: DownloadFinishedEvent(),
                                        userInfo: nil)
    }
    
    private func publishDownloadProgress(progress:CGFloat) {
        NotificationCenter.default.post(name:.onDownloadProgress,
                                        object: DownloadProgressEvent(progress: progress),
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
