//
//  SideBarView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI
import PencilKit

class SideBarView: ObservableObject {
    @Published var layers = [Layer(layer: 0, thumbnail: Image(uiImage: UIImage()))]
    @Published var selectedLayer = 0
    @State var parentView: UIView = UIView()
    
    init() {
        //self.layers[0].canvasView.onSaved = self.layers[0].UpdateImage
    }
    
    var body: some View {
        VStack {
            ForEach(layers) { layer in
                Button { [self] in
                    self.selectedLayer = layer.layerIndex
                    var curLayer = layers[selectedLayer]
                    parentView.bringSubviewToFront(curLayer.canvasView!.pkCanvasView)
                } label: {
                
                    layer.thumbnail
                        .resizable()
                        .frame(width:110, height: 90)
                        .background(.clear)
                    
                        .border(layer === self.layers[self.selectedLayer] ? .red : .blue)
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
    
    func RegisterParentView(uiView: UIView) {
        self.parentView = uiView
        uiView.addSubview(layers[0].canvasView!.pkCanvasView)
    }
    
    func AddLayer() {
        selectedLayer = layers.count
        var newLayer  = Layer(layer: selectedLayer, thumbnail: Image(uiImage: UIImage()))
        //newLayer.canvasView.onSaved = newLayer.UpdateImage
        self.layers.append(newLayer)
        parentView.addSubview(newLayer.canvasView!.pkCanvasView)
        parentView.bringSubviewToFront(newLayer.canvasView!.pkCanvasView)
    }
    
    func SelectLayer(index: Int) {
        self.selectedLayer = index
    }
    

    
    func GetCurrentLayer() -> Layer {
        return layers[self.selectedLayer]
    }
}
