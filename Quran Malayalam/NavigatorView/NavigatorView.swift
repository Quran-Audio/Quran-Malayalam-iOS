//
//  NavigatorView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 26/01/22.
//

import SwiftUI

struct NavigatorView<LeftIcons,RightIcons>: View where LeftIcons : View,
                                                       RightIcons : View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showBackButton:Bool = false
    @State var title:String = ""
    @ViewBuilder var leftItems: LeftIcons
    @ViewBuilder var rightItems: RightIcons
    
    var body: some View {
        HStack {
            if showBackButton {
                backButton
            }
            leftItems
            Spacer()
            titleSection
            Spacer()
            rightItems
        }
        .padding()
        .accentColor(ThemeService.whiteColor)
        .foregroundColor(ThemeService.whiteColor)
        .background(ThemeService.themeColor.ignoresSafeArea(edges:.top))
        .frame(height: 55)
    }
}

extension NavigatorView {
    @ViewBuilder var backButton: some View {
        Button {
            self.mode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title)
                .font(.system(size: 20))
        }
    }
    
    @ViewBuilder var titleSection: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            NavigatorView(showBackButton: true,
                          title: "Quran Malayalam") {
                Button {
                    
                } label: {
                    Image(systemName: "play")
                        .foregroundColor(.white)
                        .font(.title)
                }

            } rightItems: {
                Button {
                    
                } label: {
                    Image(systemName: "pause")
                        .foregroundColor(.white)
                }
            }

            Spacer()
        }
    }
}
