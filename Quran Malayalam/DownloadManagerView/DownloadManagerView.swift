//
//  DownloadView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 17/01/22.
//

import SwiftUI

struct DownloadView: View {
    @ObservedObject var viewModel = DownloadManagerViewModel(
        model: ChapterModel(index: 1,
                            name: "ٱلْفَاتِحَة",
                            nameEn: "Al-Fatihah",
                            nameMl: "-",
                            fileName: "000_Al_Fattiha.mp3",
                            size: "768Kb",
                            durationInSecs: 98),
        baseUrl: "https://archive.org/download/malayalam-meal/"
    )
    var body: some View {
        GeometryReader { geometry in
            VStack {
                DownloadProgressView(viewModel: viewModel)
                Text(viewModel.chapterName).font(ThemeService.shared.arabicFont(size: 40))
                Text(viewModel.chapterNameEN).font(.title)
                Text("Size: \(viewModel.chapterSize)").font(.title2)
                Button {
                    self.viewModel.startDownload()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Start").font(.title2)
                    }
                    
                }.padding()
                Spacer()
            }
        }
    }
}

struct DownloadProgressView:View {
    @ObservedObject var viewModel:DownloadManagerViewModel
    var padding:CGFloat = 10
    var lineWidth:CGFloat = 17
    var body: some View {
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
                Text("\(viewModel.progressText)").font(.system(size: 70))
            }
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
