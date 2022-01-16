//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterCell:View {
    var chapter:ChapterModel
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                    .foregroundColor(ThemeService.themeColor)
                Text("\(chapter.index)").foregroundColor(.white).font(.system(size: 20))
            }
            VStack(alignment:.leading) {
                Text("سورة \(chapter.name)")
                    .font(ThemeService.shared.arabicFont(size: 20))
                    .offset(y:3)
                Text("Surah \(chapter.nameEn)")
                    .foregroundColor(ThemeService.subTitleColor)
                    .offset(y:-3)
            }
            Spacer()
            Button {
                
            } label: {
                Image("more")
                    .resizable()
                    .frame(width: 25 , height: 25)
            }

        }.foregroundColor(ThemeService.titleColor)
            .padding(.horizontal,7)
//        VStack {
//            ZStack {
//                HStack {
//                    ZStack {
//                        Image(systemName: "octagon").font(.system(size: 45))
//                        Text("\(chapter.index)").font(.system(size: 20))
//                    }
//                    VStack(alignment: .leading) {
//                        Text("سورة \(chapter.name)").font(.system(size: 20))
//                        Text("Surah \(chapter.nameEn)").font(.system(size: 20)).foregroundColor(.gray)
//                    }
//                    Spacer()
//                    Image(systemName: "ellipsis.circle").font(.system(size: 30))
//                }.padding()
//                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                .strokeBorder(lineWidth:1))
//
//            }
//        }
//        .cornerRadius(20)
//        .padding(.horizontal, 5.0)
    }
}
