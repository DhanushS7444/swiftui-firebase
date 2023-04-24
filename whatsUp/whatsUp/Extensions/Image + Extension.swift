//
//  Image + Extension.swift
//  whatsUp
//
//  Created by Dhanush S on 15/04/23.
//

import Foundation
import SwiftUI

extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
