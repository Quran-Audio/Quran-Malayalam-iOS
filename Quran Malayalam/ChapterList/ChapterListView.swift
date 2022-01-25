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
    var body: some View {
        VStack(spacing:0) {
            ZStack(alignment: .bottom) {
                VStack(spacing:0) {
                    NaviagationView(viewModel: viewModel,
                                    playerCellViewModel:playerCellViewModel,
                                    fullPlayerFrameHeight:$fullPlayerFrameHeight,
                                    fullPlayerOpacity:$fullPlayerOpacity)
                }
                FullPlayerView(frameHeight: $fullPlayerFrameHeight,
                               opacity:$fullPlayerOpacity)
                    .shadow(color: ThemeService.whiteColor.opacity(0.2),
                            radius: 1,
                            x: 0,
                            y: -1)
            }
        }
        .background(ThemeService.themeColor)
    }
    
    struct NaviagationView: View {
        @ObservedObject var viewModel:ChapterListViewModel
        @ObservedObject var playerCellViewModel:PlayerCellViewModel
        @Binding var fullPlayerFrameHeight:CGFloat
        @Binding var fullPlayerOpacity:CGFloat
        
        var body: some View {
            NavigationView {
                VStack(spacing:0) {
                    ScrollView {
                        if viewModel.chapters.count == 0 {
                            emptyListView
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
                }
                .navigationBarTitle("Quran Malayalam",displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            Text("")
                            NavigationLink(destination: DownloadQueueView()) {
                                Image(systemName: "gearshape")
                            }.accentColor(ThemeService.themeColor)
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            actionSheet()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .foregroundColor(.white)
                .background(ThemeService.themeColor)
                
            }
            .onAppear {
                ThemeService.shared.navigationAppearance()
            }
        }
        
        @ViewBuilder private var emptyListView: some View {
            HStack {
                Spacer()
                if viewModel.listType == .downloads {
                    Text("Empty Download List")
                }else if viewModel.listType == .favourites {
                    Text("Empty Favourites List")
                }
                Spacer()
            }
        }
        
        @ViewBuilder private var chapterListView: some View {
            VStack(spacing:10) {
                Spacer(minLength: 5)
                ForEach(viewModel.chapters, id: \.index) { chapter in
                    ChapterCell(viewModel: viewModel,
                                chapter:chapter)
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
        }
    }
    
    
}

struct ChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterListView()
        //.previewInterfaceOrientation(.landscapeLeft)
    }
}
