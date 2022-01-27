//
//  ToastView.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 27/01/22.
//

import SwiftUI

struct ToastView: View {
    @EnvironmentObject var toastData:ToastData
    var body: some View {
        VStack(spacing:10) {
            HStack {
                image
                    .font(.system(size: 20))
                Text(toastData.title)
                    .font(.system(size: 20))
            }
            Text(toastData.description)
                .font(.system(size: 18))
                .foregroundColor(ThemeService.whiteColor.opacity(0.7))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.toastData.showToast = false
            }
        }
        .padding(.all)
        .foregroundColor(ThemeService.whiteColor)
        .background(ThemeService.themeColor)
        .cornerRadius(15)
        .shadow(color: ThemeService.themeColor.opacity(0.7),
                radius: 3, x: 1, y: 1)
        
    }
        
    
    enum ToasType {
        case info,warning,error
    }
    
    @ViewBuilder var image: some View {
        switch toastData.type {
        case .info:
            Image(systemName: "info.circle")
        case .warning:
            Image(systemName: "exclamationmark.triangle")
        case .error:
            Image(systemName: "xmark.circle")
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView().environmentObject(ToastData())
    }
}

