//
//  ChapterListView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterListView: View {
    @ObservedObject var viewModel = ChapterListViewModel()
    
    init(listType:EListType) {
        viewModel.listType = listType
    }

    var body: some View {
        VStack(spacing:0) {
            NavigationView {
                ScrollView {
                    if viewModel.chapters.count == 0 {
                        emptyListView
                    }else {
                        chapterListView
                    }
                }
                .navigationBarTitle("Quran Malayalam",displayMode: .inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                print("Test")
                            } label: {
                                Image(systemName: "gearshape")
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
                navigationAppearance()
            }
            if let _ = viewModel.currentChapter {
                PlayerCellView(viewModel: viewModel)
            }
        }.onAppear {
            //FIXME: Just to update the whole view
            self.viewModel.listType = self.viewModel.listType
        }
    }
    
    private func actionSheet() {
        let data = viewModel.shareText
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    private func navigationAppearance()  {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor(ThemeService.themeColor)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
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
        }
        .background(.white)
    }
}

struct ChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterListView(listType: .downloads)
    }
}
