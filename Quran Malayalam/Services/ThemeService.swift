//
//  ThemeService.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

class ThemeService {
    static let secondaryColor = Color("secondaryColor")
    static let whiteColor = Color.white
    static let themeColor = Color("theme")
    static let subTitleColor = Color("subTitle")
    static let titleColor = Color("title")
    static let borderColor = Color("borderColor")
    static let colorSet = [
        Color("type1"),
        Color("type2"),
        Color("type3"),
        Color("type4"),
        Color("type5"),
        Color("type6"),
        Color("type7"),
        Color("type8"),
        Color("type9"),
        Color("type10"),
        Color("type11"),
        Color("type12"),
        Color("type13"),
        Color("type14"),
        Color("type15"),
        Color("type16"),
        Color("type17")
    ]
    
    
    
    
    static let shared = ThemeService()
    private init() {}
    
    func arabicFont(size:CGFloat) -> Font {
        Font.custom("XB Niloofar", size: size)
    }
}
