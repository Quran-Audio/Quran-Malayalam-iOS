//
//  ChapterCellView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterCell:View {
    @State var showSwipeButtons:Bool = false
    var onFavourite:(ChapterModel) -> Void = { _ in }
    var onDownload:(ChapterModel) -> Void = { _ in }
    var chapter:ChapterModel
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.secondarySystemBackground))
                        //.strokeBorder(ThemeService.borderColor,lineWidth: 2)
                        .frame(height: 70)
                        //.padding()
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color(UIColor.tertiaryLabel.withAlphaComponent(0.1)))
                                .frame(width: 40, height: 70, alignment: .leading)
                            
                            Text("\(chapter.index)")
                                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.5)))
                                .font(.system(size: 19))
                        }
                        VStack(alignment:.leading) {
                            Text("سورَة \(chapter.name)")
                                .font(ThemeService.shared.arabicFont(size: 20))
                                .foregroundColor(ThemeService.titleColor)
                            Text("Surah \(chapter.nameEn)")
                                .font(.system(size: 15))
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        Spacer()
                        Button {
                            showSwipeButtons.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: 90.0))
                                .frame(width: 50, height: 70)
                                .foregroundColor(Color.blue)    // Theme Color will come here
                        }
                    }

                }
                .background(Color(UIColor.systemBackground))
                .offset(x: showSwipeButtons ? -88 : 0)
                .animation(.spring(dampingFraction: 0.5),
                           value: showSwipeButtons)
            }
            if showSwipeButtons {
                HStack(spacing:0){
                    ZStack {
                        Rectangle()
                            .fill(ThemeService.themeColor.opacity(0.8))
                            .frame(width: 44, height: 44)
                        Button {
                            onDownload(chapter)
                            showSwipeButtons.toggle()
                        } label: {
                            let isDownloaded = DataService.shared.isDownloaded(index: chapter.index)
                            Image(systemName: isDownloaded ? "checkmark.icloud.fill" : "icloud.and.arrow.down")
                        }
                    }
                    ZStack {
                        Rectangle()
                            .fill(ThemeService.themeColor.opacity(0.7))
                            .frame(width: 44, height: 44)
                        Button {
                            onFavourite(chapter)
                            showSwipeButtons.toggle()
                        } label: {
                            let isFavourite = DataService.shared.isFavourite(index: chapter.index)
                            Image(systemName: isFavourite ? "star.fill": "star")
                        }
                    }
                }.foregroundColor(ThemeService.whiteColor)
            }
            
        }.foregroundColor(ThemeService.titleColor)
            .padding(.horizontal,7)
    }
}

struct ChapterCell_Previews: PreviewProvider {
    static var previews: some View {
        ChapterCell(chapter:ChapterModel(index: 1,
                                         name: "ٱلْفَاتِحَة",
                                         nameEn: "Al-Fatihah",
                                         nameMl: "-",
                                         fileName: "000_Al_Fattiha.mp3",
                                         size: "768Kb",
                                         durationInSecs: 98))
            .preferredColorScheme(.light)
        ChapterCell(chapter:ChapterModel(index: 1,
                                         name: "ٱلْفَاتِحَة",
                                         nameEn: "Al-Fatihah",
                                         nameMl: "-",
                                         fileName: "000_Al_Fattiha.mp3",
                                         size: "768Kb",
                                         durationInSecs: 98))
            .preferredColorScheme(.dark)

    }
}

