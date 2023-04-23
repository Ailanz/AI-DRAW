//
//  ThumbnailView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI


class ThumbnailView : ObservableObject, Identifiable {
    
    @Published var layer : Layer
    let id = UUID()

    init(layer: Int) {
        self.layer = Layer(layer: layer)
    }
    
    static func CreateLayer(index: Int) -> ThumbnailView {
        return ThumbnailView(layer: index)
    }

    func Update(uiImage : UIImage) {
        print("Updating img")
        self.objectWillChange.send()

        layer.image = Image(uiImage: uiImage)
        //layer.UpdateImage(uiImage: uiImage)
    }
    
    func GetView() -> Image {
        return layer.image
    }
   
}
