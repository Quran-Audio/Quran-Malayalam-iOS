//
//  DownloadService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 13/01/22.
//

import Foundation

class DownloadService {
    static var shared = DownloadService()
    private init() {}
    
    func downloadFile(url sourceUrl:String,
                      filename:String?,
                      overWrite:Bool = false,
                      onCompletion complete:@escaping (Bool,String,URL?) -> Void) {
        
        guard let url = URL(string: sourceUrl) else {
            complete(false,"Invalid URL",nil)
            return
        }
        
        do {
            try url.download(to: .documentDirectory,
                         fileName: filename,
                         overwrite: overWrite) { url, error in
                guard let url = url else { return }
                complete(true,"Success",url)
            }
        } catch {
            complete(false,error.localizedDescription,nil)
            print(error)
        }
    }
}
