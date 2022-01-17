//
//  HomeView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 16/01/22.
//

import SwiftUI

struct HomeView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        UITabBar.appearance().backgroundColor = UIColor(ThemeService.themeColor)
        UITabBar.appearance().barTintColor = UIColor(ThemeService.themeColor)
    }
    var body: some View {
        
        TabView {
            ChapterListView(listType: .all).tabItem {
                Image(systemName: "house")
            }
            ChapterListView(listType: .downloads).tabItem {
                Image(systemName: "square.and.arrow.down")
            }
            ChapterListView(listType: .favourites).tabItem {
                Image(systemName: "star")
            }
        }
        .accentColor(.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
