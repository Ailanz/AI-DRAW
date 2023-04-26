//
//  Layer.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI
import PencilKit

class Layer : ObservableObject, Identifiable, Equatable{
    //layer order
    @Published var layerIndex : Int
    @Published var thumbnail : Image
    @Published var hidden = false
    @Published var canvasView : CanvasView? = nil
    
    //such a stupid f'in hack. Must update parent to trigger ui reload
    @Published var parent: LayersModel
    
    
    init(layer: Int, thumbnail: Image, parent: LayersModel) {
        self.layerIndex = layer
        let pkCanvasView = PKCanvasView()
        self.thumbnail = thumbnail
        self.parent = parent
        self.canvasView = CanvasView(onSaved: UpdateImage, pkCanvasView: pkCanvasView, thumbnail: thumbnail)
    }
    
    func UpdateImage() {
        print("Updating thumbnail {%s}. Stroke Count:", layerIndex, canvasView!.pkCanvasView.drawing.strokes.count)
        thumbnail = Image(uiImage: canvasView!.pkCanvasView.drawing.image(from: canvasView!.pkCanvasView.bounds, scale: 1.0))
        
        //triger reload
        parent.b = !parent.b
    }
    
    static func == (lhs: Layer, rhs: Layer) -> Bool {
        return lhs.layerIndex == rhs.layerIndex
    }
    
}


