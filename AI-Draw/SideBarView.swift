//
//  SideBarView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI

class SideBarView: ObservableObject {
    @Published var layers = [ThumbnailView.CreateLayer(index: 0)]
    @Published var selectedLayer = 0
    
    var body: some View {
        VStack {
            ForEach(layers) { layer in
                layer.GetView()
                    .resizable()
                    .frame(width:110, height: 90)
                    .background(.clear)
                    .border(.red)
            }
        }
    }
}

extension SideBarView {
    
    func GetView() ->some View {
        return  body
    }
    
    func SelectLayer(index: Int) {
        self.selectedLayer = index
    }
    
    func GetCurrenThumbnail() -> ThumbnailView {
        self.objectWillChange.send()
        return layers[selectedLayer]
    }
    
    func GetCurrentLayer() -> Layer {
        return GetCurrenThumbnail().layer
    }
}
