//
//  ChapterListView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterListView: View {
    @ObservedObject var viewModel = ChapterListViewModel()
    @ObservedObject var playerCellViewModel = PlayerCellViewModel()
    @State var fullPlayerFrameHeight:CGFloat = 0
    @State var fullPlayerOpacity:CGFloat = 0
    @State var showToast:Bool = false
    @State var toastTitle:String = ""
    @State var toastDescriptiom:String = ""
    @State var toastType:ToastView.ToasType = .info
    
    var body: some View {
        VStack {
            ZStack(alignment:.bottom) {
                VStack(spacing:0)  {
                    ScrollView {
                        if viewModel.chapters.count == 0 {
                            Spacer(minLength: 20)
                            emptyListView
                            Spacer()
                        }else {
                            chapterListView
                        }
                    }
                    if AudioService.shared.isCurrentChapterAvailable() {
                        PlayerCellView(viewModel: playerCellViewModel)
                            .onTapGesture {
                                fullPlayerFrameHeight = 250
                                fullPlayerOpacity = 1
                            }
                    }
                    TabBarView(viewModel: viewModel)
                        .background(ThemeService.themeColor)
                }
                .navigatorView(title: "Quran Malayalam") {
                    Button {
                        actionSheet()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                    }
                } rightItems: {
                    NavigationLink(destination: DownloadQueueView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                    }
                }
                FullPlayerView(frameHeight: $fullPlayerFrameHeight,
                               opacity:$fullPlayerOpacity)
            }
        }
        .background(ThemeService.themeColor)
        .toast(showToast: $showToast,
               title: toastTitle,
               description: toastDescriptiom,
               type:toastType)
    }
    
    //MARK: View Builders
    @ViewBuilder private var emptyListView: some View {
        VStack {
            HStack {
                Spacer()
                if viewModel.listType == .downloads {
                    Text("Empty Download List")
                }else if viewModel.listType == .favourites {
                    Text("Empty Favourites List")
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    @ViewBuilder private var chapterListView: some View {
        VStack(spacing:10) {
            Spacer(minLength: 5)
            ForEach(viewModel.chapters, id: \.index) { chapter in
                ChapterCell(onFavourite: { chapter in
                    if viewModel.isFavourite(chapter: chapter) {
                        toastTitle = "Removed from favourites"
                    }else {
                        toastTitle = "Added to favourites"
                    }
                    self.showToast = true
                    viewModel.onFavouriteChapter(chapterIndex: chapter.index)
                },
                            onDownload: { chapter in
                    if viewModel.isDownloaded(chapter: chapter) {
                        toastTitle = "Deleted file."
                    }else {
                        toastTitle = "Added to download queue."
                    }
                    self.showToast = true
                    viewModel.onDownloadChapter(chapter:chapter)
                },
                            chapter: chapter)
                    .contentShape(Rectangle())
                    .onTapGesture {
                    self.viewModel.setCurrent(chapter: chapter)
                }
            }
            Spacer(minLength: 5)
        }
        .background(.white)
    }
    
    private func actionSheet() {
        let data = viewModel.shareText
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    
    struct TabBarView: View {
        @ObservedObject var viewModel:ChapterListViewModel
        var body: some View {
            HStack(spacing:0) {
                ZStack {
                    Rectangle()
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.system(size: 23))
                        Text("Home")
                            .font(.system(size: 15))
                    }.foregroundColor(viewModel.listType == .all ? ThemeService.whiteColor : ThemeService.borderColor.opacity(0.7))
                }.onTapGesture {
                    if viewModel.listType != .all {
                        viewModel.listType = .all
                    }
                }
                ZStack {
                    Rectangle()
                    VStack {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 23))
                        Text("Downloads")
                            .font(.system(size: 15))
                    }.foregroundColor(viewModel.listType == .downloads ? ThemeService.whiteColor : ThemeService.borderColor.opacity(0.7))
                }.onTapGesture {
                    if viewModel.listType != .downloads {
                        viewModel.listType = .downloads
                    }
                }
                ZStack {
                    Rectangle()
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 23))
                        Text("Favourites")
                            .font(.system(size: 13))
                    }.foregroundColor(viewModel.listType == .favourites ? ThemeService.whiteColor : ThemeService.borderColor.opacity(0.7))
                }.onTapGesture {
                    if viewModel.listType != .favourites {
                        viewModel.listType = .favourites
                    }
                }
            }
            .foregroundColor(ThemeService.themeColor)
            .frame(height: 60)
            .background(ThemeService
                            .themeColor
                            .ignoresSafeArea(edges:.bottom))
        }
    }
    
    
}

struct ChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterListView()
        //.previewInterfaceOrientation(.landscapeLeft)
    }
}
