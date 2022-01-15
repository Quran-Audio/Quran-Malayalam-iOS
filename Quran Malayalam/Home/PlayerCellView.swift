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
                        Image(systemName: viewModel.isPlaying ? "speaker.wave.2" : "octagon").font(.system(size: 45))
                        if !viewModel.isPlaying {
                            Text("\(viewModel.currentChapter?.index ?? 0)")
                                .font(.system(size: 20))
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("سورة \(viewModel.currentChapter?.name ?? "")")
                            .font(.system(size: 20))
                        Text("Surah \(viewModel.currentChapter?.nameEn ?? "")")
                            .font(.system(size: 20)).foregroundColor(.secondary)
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
                }.padding(.leading,5)
                Rectangle()
                    .strokeBorder(lineWidth:2)
                    .shadow(color: .gray, radius: 3, x: 1, y: -1).frame( height: 75)
            }
        }.background(.tertiary)
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
