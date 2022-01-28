//
//  ToastView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 27/01/22.
//

import SwiftUI

struct ToastView: ViewModifier {
    @Binding var showToast:Bool
    var title:String = ""
    var description:String = ""
    var type:ToasType = .info
    var alignment:Alignment = .center
    var duration:CGFloat = 1
    
    func body(content:Content) -> some View {
        ZStack(alignment: alignment) {
            content
            if showToast {
                VStack(spacing:10) {
                    HStack {
                        image
                            .font(.system(size: 20))
                        Text(title)
                            .font(.system(size: 20))
                    }
                    if(!description.isEmpty) {
                        Text(description)
                            .font(.system(size: 18))
                            .foregroundColor(ThemeService.whiteColor.opacity(0.7))
                    }
                }
                .padding()
                .foregroundColor(ThemeService.whiteColor)
                .background(ThemeService.themeColor)
                .cornerRadius(15)
                .shadow(color: ThemeService.themeColor.opacity(0.7),
                        radius: 3, x: 1, y: 1)
                
            }
        }.onChange(of: showToast) { newValue in
            if showToast {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation(.spring()) {
                        showToast = false
                    }
                }
            }
        }
        
    }
        
    enum ToasType {
        case info,warning,error
    }
    
    @ViewBuilder var image: some View {
        switch type {
        case .info:
            Image(systemName: "info.circle")
        case .warning:
            Image(systemName: "exclamationmark.triangle")
        case .error:
            Image(systemName: "xmark.circle")
        }
    }
}

extension View {
    func toast(showToast:Binding<Bool>,
               title:String = "",
               description:String = "",
               type:ToastView.ToasType = .info,
               alignment:Alignment = .center) -> some View {
        modifier(ToastView(showToast: showToast,
                           title: title,
                           description: description,
                           type: type,
                           alignment: alignment))
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Test")
            Spacer()
            HStack{
                Spacer()
            }
        }.toast(showToast: .constant(true),
                title: "Some Title",
                description: "Some Description",
                alignment: .bottom)
            .background(ThemeService.whiteColor)
        
    }
}

