//
//  ToastData.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 27/01/22.
//

import Foundation

class ToastData:ObservableObject {
    @Published var showToast:Bool = false
    var title:String = ""
    var description:String = ""
    var type:ToastView.ToasType = .info
    var duration:Int = 3
    
    init(title:String = "",description:String = "",type:ToastView.ToasType = .info,duration:Int = 3) {
        self.title = title
        self.description = description
        self.type = type
        self.duration = duration
    }
}
