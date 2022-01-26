//
//  DownnloadCell.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 24/01/22.
//

import SwiftUI

struct DownloadQueueView: View {
    @ObservedObject var viewModel = DownloadQueueViewModel()
    var padding:CGFloat = 5
    var lineWidth:CGFloat = 5
    var body: some View {
        VStack {
            NavigatorView(showBackButton: true,
                          title: "Settings") {
                Text("").opacity(0)
            } rightItems: {
                Text("").opacity(0)
            }
            Spacer(minLength: 20)
            ScrollView {
                VStack(spacing:0) {
                    if viewModel.downloadQueue.count > 0 {
                        circularProgress
                            .frame(height:150)
                        VStack(spacing:10) {
                            title
                            buttonPanel
                        }
                        Spacer(minLength: 10)
                        Divider()
                        Spacer(minLength: 20)
                        ScrollView {
                            VStack(spacing:15) {
                                Section("Download Queue"){
                                    ForEach(viewModel.downloadQueue, id: \.index) { chapter in
                                        DownloadQueueCell(viewModel: viewModel,
                                                          chapter:chapter)
                                    }
                                }
                            }
                        }
                    }else {
                        Text("Empty Download queue")
                    }
                    Spacer()
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
    
    struct DownloadQueueCell: View {
        @ObservedObject var viewModel:DownloadQueueViewModel
        var chapter:ChapterModel
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .strokeBorder(ThemeService.borderColor,lineWidth: 1)
                HStack {
                    VStack(alignment:.leading) {
                        Text("\(chapter.name)")
                            .foregroundColor(ThemeService.themeColor)
                            .font(.system(size: 20))
                        Text("\(chapter.nameEn)")
                            .foregroundColor(ThemeService.themeColor.opacity(0.7))
                            .font(.system(size: 17))
                    }
                    .offset(x:15)
                    Spacer()
                    Text("\(chapter.size)MB").font(.system(size: 15))
                    Button {
                        viewModel.removeFromDownloadQueueList(chapter: chapter)
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }.frame(width: 44, height: 44)
                }.padding(.all,5)
            }.padding(.horizontal,20)
            
        }
    }
    @ViewBuilder var buttonPanel:some View {
        HStack(spacing:0) {
            Button {
                viewModel.startDownload()
            } label: {
                Image(systemName: viewModel.isDownloading ? "pause":"play")
                    .font(.system(size: 30))
                    .foregroundColor(ThemeService.themeColor)
                    .padding(.horizontal)
            }
            Button {
                viewModel.cancelDownload()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder var circularProgress: some View {
        GeometryReader { geometry in
            ZStack {
                let radius = min(geometry.size.width/2,geometry.size.height/2) - padding - lineWidth
                let midPoint = CGPoint(x: geometry.size.width/2,
                                       y: geometry.size.height/2)
                Path { path in
                    path.addArc(center: midPoint,
                                radius: radius,
                                startAngle: Angle(degrees: 0),
                                endAngle: Angle(degrees: 360),
                                clockwise: false)
                }.stroke(.red.opacity(0.1), style: StrokeStyle(lineWidth: lineWidth + 2,
                                                               lineCap: .square,
                                                               lineJoin: .bevel))
                Path { path in
                    path.addArc(center: midPoint,
                                radius: radius,
                                startAngle: Angle(degrees: 0 - 90),
                                endAngle: Angle(degrees:  viewModel.progressInPi - 90),
                                clockwise: false)
                }.stroke(.green, style: StrokeStyle(lineWidth: lineWidth,
                                                    lineCap: .round,
                                                    lineJoin: .bevel))
                
                Text(String(format: "%.1f %%", viewModel.progress*100))
                    .font(.system(size: 20))
            }
        }
    }
    
    @ViewBuilder var title: some View {
        VStack{
            Text("\(viewModel.chapterName)")
                .font(ThemeService.shared.arabicFont(size: 25))
                .foregroundColor(ThemeService.themeColor)
            Text("\(viewModel.chapterTrans)")
                .font(.system(size: 20))
                .foregroundColor(ThemeService.themeColor.opacity(0.7))
        }
    }
}

struct DownnloadCell_Previews: PreviewProvider {
    static var previews: some View {
        DownloadQueueView()
    }
}
