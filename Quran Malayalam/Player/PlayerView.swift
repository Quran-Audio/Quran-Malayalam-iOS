//
//  PlayerView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 10/01/22.
//

import SwiftUI

struct PlayerView: View {
    @ObservedObject private var viewModel = PlayerViewModel()

    var body: some View {
        VStack(spacing:20){
            AudioTitle(title: viewModel.chapterName)
            AudioButtonPanel(viewModel: viewModel)
            AudioSlider(viewModel: viewModel)
        }
        .foregroundColor(.white)
        .background(Color(red: 0.478, green: 0.478, blue: 0.996))
        .cornerRadius(10)
        .padding(10.0)
    }
    
    struct AudioSlider:View {
        @ObservedObject var viewModel:PlayerViewModel
        
        @State private var currentTime:String = "0:00"
        private let audioDurationTimer = Timer.publish(every: 1,
                                               on: .main,
                                               in: .common).autoconnect()
        @State private var sliderValue:CGFloat = 0
        var body: some View {
            VStack(spacing:20){
                Slider(value: $sliderValue,in: 0...viewModel.sliderMaxValue)
                { isEdited in
                    viewModel.seekTo(seconds: sliderValue)
                }.onReceive(audioDurationTimer,
                            perform: { _ in
                    self.sliderValue = viewModel.sliderCurrentValue
                }).accentColor(.white)
                    .padding(.horizontal)
                    .offset(y:10)
                
                HStack() {
                    Text("\(currentTime)")
                        .onReceive(audioDurationTimer) { _ in
                            currentTime = viewModel.currentTimeText
                        }
                    Spacer()
                    Text("\(viewModel.durationText)")
                }
                .font(.system(size: 14))
                .offset(y: -10)
                .padding(.horizontal)
            }
        }
    }

    struct AudioButtonPanel:View {
        @ObservedObject var viewModel:PlayerViewModel
        
        var body: some View {
            HStack(spacing: 30) {
                Button {
                    print("backward")
                } label: {
                    Image(systemName: "backward")
                }
                .font(.system(size: 20))
                ZStack {
                    if viewModel.isBuffering {
                        LoaderView()
                    }
                    Button {
                        viewModel.playPause()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause" : "play")
                    }
                    .font(.system(size: 40))
                    
                }
                
                Button {
                    print("forward")
                } label: {
                    Image(systemName: "forward")
                }
                .font(.system(size: 20))
                
            }.offset(y:20)
        }
    }

    struct AudioTitle:View {
        var title:String
        
        var body: some View {
            Text(title)
                .font(.system(size:24))
                .scaledToFit()
                .offset(y:10)
        }
    }

    struct LoaderView:View {
        var tintColor:Color = .white
        var scaleSize:CGFloat = 2.5
        
        var body: some View {
            ProgressView()
                .scaleEffect(scaleSize,anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
        }
    }
}



struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
