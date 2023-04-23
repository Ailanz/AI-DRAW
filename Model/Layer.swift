//
//  Layer.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI
import PencilKit

class Layer : ObservableObject{
    @Published var layerIndex : Int
    @Published var image = Image(uiImage: UIImage())
    @Published var hidden = false
    @Published var drawing = PKDrawing()
    init(layer: Int) {
        self.layerIndex = layer
    }
    
    func AddStroke(stroke : PKStroke) {
        drawing.strokes.append(stroke)
    }
    
    func UpdateImage(bounds: CGRect) {
        image = Image(uiImage:drawing.image(from: bounds, scale: 1.0))
    }
}


