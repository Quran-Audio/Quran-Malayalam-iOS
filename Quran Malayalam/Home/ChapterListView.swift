//
//  ChapterListView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ChapterListView: View {
    @ObservedObject private var viewModel = ChapterListViewModel()
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack {
                        ForEach(viewModel.chapters, id: \.index) { chapter in
                            ChapterCell(chapter:chapter).onTapGesture {
                                self.viewModel.setCurrent(chapter: chapter)
                            }
                        }
                    }
                    
                }.navigationTitle(Text("Chapters"))
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
                    }.foregroundColor(.black)
            }
            if let _ = viewModel.currentChapter {
                PlayerCellView(viewModel: viewModel)
            }
        }
    }
    
    func actionSheet() {
        let data = viewModel.shareText
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }

}

struct ChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterListView()
    }
}
