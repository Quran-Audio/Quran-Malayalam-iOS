//
//  File.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 11/01/22.
//

import Foundation

struct PlayingModel:Codable {
    let name: String
    var durationInSec: Int
    let streamUrl: String
    let downloadUrl: String
    var isPlaying:Bool
}
