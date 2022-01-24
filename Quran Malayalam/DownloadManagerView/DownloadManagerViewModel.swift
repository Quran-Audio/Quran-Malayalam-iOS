//
//  DownloadManagerViewModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 17/01/22.
//

import UIKit

class DownloadManagerViewModel:ObservableObject {
    private var model:ChapterModel?
    private var baseUrl:String?
    @Published var progressText:String = "0%"
    @Published var progressPercent:Int = 0
    @Published var progressInPi:CGFloat = 0
    
    var chapterName:String {model?.name ?? ""}
    var chapterNameEN:String {model?.nameEn ?? ""}
    var chapterSize:String {model?.size ?? ""}
    
    
    init(model:ChapterModel,baseUrl:String) {
        self.model = model
        self.baseUrl = baseUrl
    }
    
    func startDownload() {
        guard let model = model,let baseUrl = baseUrl else {return}

//        DownloadService.shared.onInvalid = {
//            self.progressText = "0%"
//            self.progressPercent = 0
//            self.progressInPi = 0
//        }
//        DownloadService.shared.onProgress = { progressPercent in
//            self.progressText = "\(progressPercent)%"
//            self.progressPercent = progressPercent
//            self.progressInPi = CGFloat((progressPercent / 100) * 360)
//        }
        do {
            let urlText = "\(baseUrl)\(model.fileName)"
            try DownloadService.shared.startDownload(urlText:urlText) { url, error in
                self.progressText = "100%"
                self.progressPercent = 100
                self.progressInPi = 360
            }
        }catch {
            self.progressText = "0%"
            self.progressPercent = 0
            self.progressInPi = 0
        }
        
    }
    
}
