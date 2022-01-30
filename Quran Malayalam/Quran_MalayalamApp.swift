//
//  Quran_MalayalamApp.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 09/01/22.
//

import SwiftUI

@main
struct Quran_MalayalamApp: App {
    init() {
        RatingService.shared.checkAndAskForReview()
        PushService.shared.askForPushPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ChapterListView()
                .preferredColorScheme(.light)
        }
    }
}
