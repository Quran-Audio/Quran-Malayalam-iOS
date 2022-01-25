//
//  DownnloadCell.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 24/01/22.
//

import SwiftUI

struct DownnloadCell: View {
    @ObservedObject var viewModel = DownloadCellViewModel()
    var body: some View {
        HStack {
            ZStack(alignment:.trailing) {
                ZStack{
                    ZStack(alignment:.leading) {
                        GeometryReader { geometry in
                            Rectangle()
                                .foregroundColor(ThemeService.borderColor)
                            Rectangle()
                                .foregroundColor(ThemeService.themeColor.opacity(0.8))
                                .frame(width: viewModel.progress * geometry.size.width)
                                .animation(.spring(dampingFraction: 0.5),
                                           value: viewModel.progress)
                        }
                    }
                    VStack {
                        Text("\(viewModel.chapterName)")
                            .font(.system(size: 15)).bold()
                        Text("\(Int(viewModel.progress*100))% Downloaded")
                            .font(.system(size: 21)).bold()
                    }
                    .foregroundColor(ThemeService.whiteColor)
                    .offset(x:-40)
                }
                HStack(spacing:0) {
                    Button {
                        viewModel.startDownload()
                    } label: {
                        Image(systemName: viewModel.isDownloading ? "pause":"play")
                            .font(.system(size: 25))
                            .foregroundColor(ThemeService.whiteColor)
                            .padding(.horizontal)
                    }.frame(width: 40)
                    Button {
                        viewModel.progress = 0
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 20))
                            .foregroundColor(ThemeService.whiteColor)
                            .padding(.horizontal)
                    }.frame(width: 40)
                }

            }.frame(height:50)
        }
    }
}

struct DownnloadCell_Previews: PreviewProvider {
    static var previews: some View {
        DownnloadCell()
    }
}
