//
//  ThemeService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

class ThemeService {
    static let themeColor = Color(red: 0.48, green: 0.48, blue: 1.00)
    static let titleColor = Color(red: 0, green: 0, blue: 0)
    static let subTitleColor = Color(red: 0.71, green: 0.74, blue: 0.74)
    
    static let shared = ThemeService()
    private init() {}
    
    func arabicFont(size:CGFloat) -> Font {
        Font.custom("XB Niloofar", size: size)
    }
}
