//
//  ProtoCell.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ProtoCell: View {
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ZStack {
                        Image(systemName: "speaker.wave.2")
                            .font(.system(size: 25))
                        Rectangle()
                            .strokeBorder(.white,lineWidth: 2)
                            .frame(width: 50, height: 50)
                        Text("114")
                            .font(ThemeService.shared.arabicFont(size: 20))
                    }
                    VStack(alignment: .leading) {
                        Text("Chpater 1")
                            .font(ThemeService.shared.arabicFont(size: 25))
                        Text("Chapter 1 en")
                            .font(.system(size: 20))
                            .foregroundColor(ThemeService.subTitleColor)
                    }
                    Spacer()
                    ZStack {
                        //if viewModel.isBuffering {
                        //LoaderView()
                        //}
                        Image(systemName: "play")
                            .font(.system(size: 25)).onTapGesture {
                                //viewModel.playPause()
                            }
                        
                    }.offset(x:-10)
                }
                .padding(.leading,5)
                
            }.padding()
        }.background(ThemeService.themeColor)
            .foregroundColor(.white)
            .shadow(color: .gray, radius: 3, x: 1, y: -1)
    }
}

struct ProtoCell_Previews: PreviewProvider {
    static var previews: some View {
        ProtoCell()
    }
}
