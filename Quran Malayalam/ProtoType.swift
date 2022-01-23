//
//  ProtoCell.swift
//  Quran Malayalam
//
//  Created by Mohammed Shafeer on 15/01/22.
//

import SwiftUI

struct ProtoType: View {
    var body: some View {
        Image(systemName: "chevron.down")
            .frame(width: 40, height: 40)
            .foregroundColor(ThemeService.whiteColor)
    }
}

struct ProtoType_Previews: PreviewProvider {
    static var previews: some View {
        ProtoType()
    }
}
