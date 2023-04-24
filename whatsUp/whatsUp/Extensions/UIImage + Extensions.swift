//
//  UIImage + Extensions.swift
//  whatsUp
//
//  Created by Dhanush S on 15/04/23.
//

import Foundation
import UIKit

extension UIImage {
    
    // stackOverFlow
    
    func resize(to size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        let widthRatio = size.width / size.width
        let heightRation = size.height / size.height
        
        var newSize: CGSize
        if (widthRatio > heightRation) {
            newSize = CGSize(width: size.width * heightRation, height: size.height * heightRation)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
