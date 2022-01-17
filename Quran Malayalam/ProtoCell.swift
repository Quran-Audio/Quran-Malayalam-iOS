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
        HStack {
            HStack {
                ZStack {
                    Rectangle()
                        .frame(width: 40, height: 40)
                        .cornerRadius(5)
                        .foregroundColor(ThemeService.themeColor)
                    Text("1").foregroundColor(.white).font(.system(size: 20))
                }
                VStack(alignment:.leading) {
                    Text("Chapter 1")
                        .font(ThemeService.shared.arabicFont(size: 20))
                        .offset(y:3)
                    Text("Chapter 1 en")
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
                            //TODO:
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    ZStack {
                        Rectangle().fill(.blue).frame(width: 44, height: 44)
                        Button {
                            //TODO:
                        } label: {
                            Image(systemName: "star")
                        }
                    }
                }.foregroundColor(.white)
            }
            
            

        }.foregroundColor(ThemeService.titleColor)
            .padding(.horizontal,7)
    }
}

struct ProtoCell_Previews: PreviewProvider {
    static var previews: some View {
        ProtoCell()
    }
}
