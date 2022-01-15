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
        VStack {
            ZStack {
                HStack {
                    ZStack {
                        Image(systemName: "octagon").font(.system(size: 45))
                        Text("\(chapter.index)").font(.system(size: 20))
                    }
                    VStack(alignment: .leading) {
                        Text("سورة \(chapter.name)").font(.system(size: 20))
                        Text("Surah \(chapter.nameEn)").font(.system(size: 20)).foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "ellipsis.circle").font(.system(size: 30))
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(lineWidth:2))
                
            }
        }
        .cornerRadius(20)
        .padding(.horizontal, 5.0)
    }
}
