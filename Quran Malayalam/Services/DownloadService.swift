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
    
    var onProgress:(Int) -> Void = {_ in}
    var onInvalid:() -> Void = {}
    
    func startDownload(urlText:String, completion: @escaping (URL?, Error?) -> Void) throws {
        guard let url = URL(string: urlText) else {return}
        
        let directory = try FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        let destination: URL
        destination = directory
            .appendingPathComponent(url.lastPathComponent)
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: .main)
        
        session.downloadTask(with: url) { location, _, error in
            guard let location = location else {
                completion(nil, error)
                return
            }
            do {
                if FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.moveItem(at: location, to: destination)
                completion(destination, nil)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("download completion")
    }
    
    // MARK: protocol stubs for tracking download progress
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        let percentDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
        print("download progress \(percentDownloaded)")
        onProgress(Int(percentDownloaded))
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        onInvalid()
    }
    
    func specialDownload() {
        guard let url = URL(string: "https://archive.org/download/malayalam-meal/000_Al_Fattiha.mp3") else {return}
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: .main)
        session.downloadTask(with: url).resume()
    }
}
