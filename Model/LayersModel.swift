//
//  LayersModel.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-25.
//

import Foundation
import SwiftUI

class LayersModel : ObservableObject {
    @Published var layers : [Layer] = [Layer(layer: 0, thumbnail: Image(uiImage: UIImage()))]
}
