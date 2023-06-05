//
//  ImageUtil.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-30.
//

import Foundation
import UIKit
import SwiftUI

class ImageUtil {
    var layerModel : LayersModel
    
    init(layerModel: LayersModel) {
        self.layerModel = layerModel
    }
    
    func getMergedImage(backgroundImage : UIImage?) -> UIImage {
        layerModel.layers.reverse()
        let firstLayer = layerModel.layers[0]
        let firstPkCanvas = firstLayer.canvasView?.pkCanvasView
        
        var uiImage = firstPkCanvas!.drawing.image(from: firstPkCanvas!.bounds, scale: 1.0)
        
        if backgroundImage != nil {
            uiImage = backgroundImage!
        }
        
        for num in (0...layerModel.layers.count-1) {
            
            let layer = layerModel.layers[num]
            uiImage = uiImage.mergeWith(topImage: layer.canvasView!.pkCanvasView.drawing.image(from: firstPkCanvas!.bounds, scale: 1.0))
        }
        layerModel.layers.reverse()
        
        
        return uiImage
    }
}

extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        
        UIGraphicsBeginImageContext(size)
        
        
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    var base64: String? {
          self.jpegData(compressionQuality: 1)?.base64EncodedString()
      }
}


extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
