//
//  SideBarView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI
import PencilKit

class SideBarView: ObservableObject {
    @Published var thumbnails = [ThumbnailView.CreateLayer(index: 0)]
    @Published var selectedLayer = 0
    
    @State var canvasView : PKCanvasView
    
    init(canvasView: PKCanvasView) {
        self.canvasView = canvasView
    }
    
    var body: some View {
        VStack {
            ForEach(thumbnails) { layer in
                Button {
                    self.selectedLayer = layer.layer.layerIndex
                } label: {
                
                    layer.GetView()
                        .resizable()
                        .frame(width:110, height: 90)
                        .background(.clear)
                    
                        .border(layer === self.thumbnails[self.selectedLayer] ? .red : .blue)
                }

                

            }
            
            Button("Add Layer") {
                self.AddLayer()
            }
        }
    }
}

extension SideBarView {
    
    func GetView() ->some View {
        return  body
    }
    
    func AddLayer() {
        selectedLayer = thumbnails.count
        self.thumbnails.append(ThumbnailView.CreateLayer(index: selectedLayer))
    }
    
    func SelectLayer(index: Int) {
        self.selectedLayer = index
    }
    
    func GetCurrentThumbnail() -> ThumbnailView {
        self.objectWillChange.send()
        return thumbnails[selectedLayer]
    }
    
    func GetCurrentLayer() -> Layer {
        return GetCurrentThumbnail().layer
    }
}
