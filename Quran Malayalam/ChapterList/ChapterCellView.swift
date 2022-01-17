//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterCell:View {
    @ObservedObject var viewModel:ChapterListViewModel
    @State var showSwipeButtons:Bool = false
    var chapter:ChapterModel
    var body: some View {
        ZStack(alignment: .trailing) {
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
                    showSwipeButtons.toggle()
                } label: {
                    Image("more")
                        .resizable()
                        .frame(width: 25 , height: 25)
                }
                
            }.offset(x: showSwipeButtons ? -88 : 0)
            if showSwipeButtons {
                HStack(spacing:0){
                    ZStack {
                        Rectangle()
                            .fill(.blue.opacity(0.8)).frame(width: 44, height: 44)
                        Button {
                            //TODO: Navigate to DownloadView
                            viewModel.onDownloadChapter(chapterIndex: chapter.index)
                            showSwipeButtons.toggle()
                        } label: {
                            let isDownloaded = DataService.shared.isDownloaded(index: chapter.index)
                            Image(systemName: isDownloaded ? "square.and.arrow.down.fill" : "square.and.arrow.down")
                        }
                    }
                    ZStack {
                        Rectangle().fill(.blue).frame(width: 44, height: 44)
                        Button {
                            viewModel.onFavouriteChapter(chapterIndex: chapter.index)
                            showSwipeButtons.toggle()
                        } label: {
                            let isFavourite = DataService.shared.isFavourite(index: chapter.index)
                            Image(systemName: isFavourite ? "star.fill": "star")
                        }
                    }
                }.foregroundColor(.white)
            }
            
            

        }.foregroundColor(ThemeService.titleColor)
            .padding(.horizontal,7)
//        HStack {
//            ZStack {
//                Rectangle()
//                    .frame(width: 40, height: 40)
//                    .cornerRadius(5)
//                    .foregroundColor(ThemeService.themeColor)
//                Text("\(chapter.index)").foregroundColor(.white).font(.system(size: 20))
//            }
//            VStack(alignment:.leading) {
//                Text("سورة \(chapter.name)")
//                    .font(ThemeService.shared.arabicFont(size: 20))
//                    .offset(y:3)
//                Text("Surah \(chapter.nameEn)")
//                    .foregroundColor(ThemeService.subTitleColor)
//                    .offset(y:-3)
//            }
//            Spacer()
//            Button {
//
//            } label: {
//                Image("more")
//                    .resizable()
//                    .frame(width: 25 , height: 25)
//            }
//
//        }.foregroundColor(ThemeService.titleColor)
//            .padding(.horizontal,7)
    }
}
