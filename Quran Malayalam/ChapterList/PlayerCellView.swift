//
//  PlayerCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct PlayerCellView: View {
    @ObservedObject var viewModel:ChapterListViewModel
    
    var body:some View {
        VStack {
            ZStack {
                HStack {
                    ZStack {
                        if viewModel.isPlaying {
                            Image(systemName: "speaker.wave.2")
                                .font(.system(size: 25))
                        }else {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .frame(width: 40, height: 40)
                            Text("\(viewModel.currentChapter?.index ?? 0)")
                                .font(ThemeService.shared.arabicFont(size: 20))
                                .foregroundColor(ThemeService.themeColor)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("سورة \(viewModel.currentChapter?.name ?? "")")
                            .font(ThemeService.shared.arabicFont(size: 25))
                            .offset(y:5)
                        Text("Surah \(viewModel.currentChapter?.nameEn ?? "")")
                            .font(.system(size: 20))
                            .foregroundColor(ThemeService.subTitleColor)
                            .offset(y:-5)
                    }
                    Spacer()
                    ZStack {
                        if viewModel.isBuffering {
                            LoaderView()
                        }
                        Image(systemName: viewModel.isPlaying ? "pause" : "play")
                            .font(.system(size: 25)).onTapGesture {
                                viewModel.playPause()
                            }
                        
                    }.offset(x:-10)
                }
                .padding(.leading,5)
                
            }
            .padding(.vertical,5)
        }.background(ThemeService.themeColor)
            .foregroundColor(.white)
            .shadow(color: .gray, radius: 1, x: 1, y: -1)
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
