//
//  ProtoCell.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ProtoCell: View {
    @State var showSwipeButtons:Bool = false
    var body: some View {
        VStack(spacing:0) {
            ZStack(alignment:.leading) {
                Rectangle().frame(height: 5)
                    .foregroundColor(ThemeService.borderColor)
                Rectangle().frame(width:10,height: 5)
                    .foregroundColor(.yellow)
            }
            HStack {
                ZStack {
                    titleBox
                    Text("1")
                        .font(.system(size: 25).bold())
                        .foregroundColor(ThemeService.whiteColor)
                }
                HStack {
                    VStack(alignment:.leading) {
                        Text("Chapter Name")
                            .foregroundColor(ThemeService.whiteColor)
                            .font(.system(size: 25))
                        Text("Chapter Name Mal")
                            .foregroundColor(ThemeService.whiteColor.opacity(0.7))
                            .font(.system(size: 20))
                    }
                    Spacer(minLength: 10)
                }
                Image(systemName: "play")
                    .foregroundColor(ThemeService.whiteColor)
                    .font(.system(size: 30))
                    .frame(width: 50,height: 50)
            }.background(ThemeService.secondaryColor)
        }
    }
    
    @ViewBuilder private var titleBox: some View {
        HStack(spacing:0) {
            Rectangle().frame(width: 60,height: 60)
                .foregroundColor(ThemeService.themeColor)
            Rectangle().frame(width: 2,height: 60)
                .foregroundColor(ThemeService.whiteColor)
        }
    }
}



struct ProtoCell_Previews: PreviewProvider {
    static var previews: some View {
        ProtoCell()
    }
}
