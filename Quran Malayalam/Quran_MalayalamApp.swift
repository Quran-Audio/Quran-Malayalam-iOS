//
//  Quran_MalayalamApp.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 09/01/22.
//

import SwiftUI
import QuranAudioPlayerKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        print("App Delegate Called")
        return true
    }
}

@main
struct Quran_MalayalamApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        RatingService.shared.checkAndAskForReview()
        PushService.shared.askForPushPermission()
        QuranAudioPlayerKit.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            QuranAudioPlayerKit()
                .preferredColorScheme(.light)
        }
    }
}
