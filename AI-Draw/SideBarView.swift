//
//  SideBarView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-22.
//

import SwiftUI
import PencilKit
import UniformTypeIdentifiers


class SideBarView: ObservableObject {
    @Published var layerModel : LayersModel
    @Published var selectedLayer = 0
    
    static var draggedLayer  : Layer?
    
    init(layerModel: LayersModel) {
        self.layerModel = layerModel
    }
    
    var body: some View {
        VStack {
            let p = print("Side View Reloaded")

            ScrollView(.vertical) {
                VStack {
                    ForEach(layerModel.layers, id: \.id) { layer in
                        Button {
                            if self.selectedLayer == layer.layerIndex {
                                self.selectedLayer = 0
                            } else {
                                self.selectedLayer = layer.layerIndex
                            }
                            
                        } label: {
                            layer.thumbnail
                                .resizable()
                                .frame(width:110, height: 90)
                                .background(.clear)
                                .border(layer === self.layerModel.getLayers()[self.selectedLayer] ? .red : .blue)
                        }
                        .onDrag({
                            SideBarView.draggedLayer = layer
                            print("Dragged", SideBarView.draggedLayer?.layerIndex ?? -1, layer.layerIndex)
                            
                            return NSItemProvider()
                        })
                        .onDrop(of: [UTType.text], delegate: LayerDropDelegate(item: layer, layersModel: self.layerModel))
                        
                        
                    }
                    
                }.padding()
            }
            .frame(height: 500)
            .background(.clear)
            .border(.black)
            
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
        selectedLayer = layerModel.getLayers().count
        layerModel.AddLayer()
    }
    
    func SelectLayer(index: Int) {
        self.selectedLayer = index
    }
    
    
    
    func GetCurrentLayer() -> Layer {
        return layerModel.getLayers()[self.selectedLayer]
    }
}
