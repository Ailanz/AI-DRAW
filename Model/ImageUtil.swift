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
}
