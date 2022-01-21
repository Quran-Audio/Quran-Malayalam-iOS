//
//  PlayerCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct PlayerCellView: View {
    @ObservedObject var viewModel = PlayerCellViewModel()
    
    var body: some View {
        VStack(spacing:0) {
            ZStack(alignment:.leading) {
                Rectangle().frame(height: 5)
                    .foregroundColor(ThemeService.borderColor)
                Rectangle().frame(width:10,height: 5)
                    .foregroundColor(.yellow)
            }
            HStack {
                ZStack {
                    titleBox
                    ZStack {
                        if viewModel.isPlaying {
                            Image(systemName: "speaker.wave.2")
                                .foregroundColor(ThemeService.whiteColor)
                                .font(.system(size: 25))
                        }else {
                            Text("\(viewModel.currentChapter?.index ?? 0)")
                                .font(.system(size: 30))
                                .foregroundColor(ThemeService.whiteColor)
                        }
                    }
                }
                HStack {
                    VStack(alignment:.leading) {
                        VStack(alignment: .leading,spacing: 0) {
                            Text("سورَة \(viewModel.currentChapter?.name ?? "")")
                                .foregroundColor(ThemeService.whiteColor)
                                .font(ThemeService.shared.arabicFont(size: 25).bold())
                            //.offset(y:3)
                            
                            Text("Surah \(viewModel.currentChapter?.nameEn ?? "")")
                                .foregroundColor(ThemeService.whiteColor.opacity(0.7))
                                .font(.system(size: 18))
                                .offset(y:-6)
                        }
                    }
                    Spacer(minLength: 10)
                }
                ZStack {
                    if viewModel.isBuffering {
                        LoaderView()
                    }
                    Image(systemName: viewModel.isPlaying ? "pause" : "play")
                        .foregroundColor(ThemeService.whiteColor)
                        .font(.system(size: 30))
                        .frame(width: 50,height: 50).onTapGesture {
                            viewModel.playPause()
                        }
                    
                }
            }
            .background(ThemeService.secondaryColor)
            Rectangle().frame(height: 0.5)
                .foregroundColor(ThemeService.borderColor)
        }
    }
    
    @ViewBuilder private var titleBox: some View {
        HStack(spacing:0) {
            Rectangle().frame(width: 50,height: 75)
                .foregroundColor(ThemeService.themeColor)
            Rectangle().frame(width: 1,height: 75)
                .foregroundColor(ThemeService.whiteColor)
        }
    }
    
    struct LoaderView:View {
        var tintColor:Color = .black
        var scaleSize:CGFloat = 1.5
        
        var body: some View {
            ProgressView()
                .scaleEffect(scaleSize,anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
        }
    }
}
