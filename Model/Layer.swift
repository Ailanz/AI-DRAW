//
//  Layer.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI
import PencilKit

class Layer : ObservableObject, Identifiable{
    //layer order
    @Published var layerIndex : Int
    @Published var thumbnail : Image
    @Published var hidden = false
    @Published var canvasView : CanvasView? = nil
    
    
    init(layer: Int, thumbnail: Image) {
        self.layerIndex = layer
        let pkCanvasView = PKCanvasView()
        self.thumbnail = thumbnail
        self.canvasView = CanvasView(onSaved: UpdateImage, pkCanvasView: pkCanvasView, thumbnail: thumbnail)
    }
    
    func UpdateImage() {
        print("Updating thumbnail {%s}. Stroke Count:", layerIndex, canvasView!.pkCanvasView.drawing.strokes.count)
        thumbnail = Image(uiImage: canvasView!.pkCanvasView.drawing.image(from: canvasView!.pkCanvasView.bounds, scale: 1.0))
        self.objectWillChange.send()
    }
    
}


