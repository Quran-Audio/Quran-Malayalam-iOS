//
//  ChapterModel.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 14/01/22.
//

import Foundation

struct DataModel:Codable {
    let baseUrl: String
    let shareText: String
    let chapters:[ChapterModel]
}

struct ChapterModel:Codable,Equatable {
    let index: Int
    let name: String
    let nameEn: String
    let nameMl: String
    let fileName: String
    let size: String
    let durationInSecs: Int
    var isPlaying:Bool? = false //Not loaded from file
    
    static func ==(lhs: ChapterModel, rhs: ChapterModel) -> Bool {
        return lhs.index == rhs.index && lhs.fileName == lhs.fileName
    }
}
