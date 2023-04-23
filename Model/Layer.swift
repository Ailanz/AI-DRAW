//
//  Layer.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI

class Layer : ObservableObject{
    @Published var layer : Int
    @Published var image = Image(uiImage: UIImage())
    @Published var hidden = false
    
    init(layer: Int) {
        self.layer = layer
    }
    
    func UpdateImage(uiImage : UIImage) {
        image = Image(uiImage: uiImage)
    }
}


