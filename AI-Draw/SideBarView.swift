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
            //let p = print("Side View Reloaded")

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
                    
                    Button("Add Layer".padding(toLength: 13, withPad: " ", startingAt: 0)) {
                        withAnimation(.default) {
                            self.AddLayer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                }.padding(7)
            }
            .frame(height: 500)
            .background(.clear)
            .border(.black)
            

            
            Button("Delete Layers".padding(toLength: 13, withPad: " ", startingAt: 0)) {
                withAnimation(.default) {
                    self.DeleteLayer()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button("Merge Layers".padding(toLength: 13, withPad: " ", startingAt: 0)) {
                withAnimation(.default) {
                    self.MergeLayers()
                }
            }
            .buttonStyle(.borderedProminent)
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
    
    func DeleteLayer() {
        let layers = layerModel.layers
        
        if layers.count == 1 || layers[0] == layers[selectedLayer] {
            layers[0].canvasView!.pkCanvasView.drawing = PKDrawing()
            layers[0].UpdateThumbnailImg()
            return
        }
        
        layerModel.layers.remove(at: selectedLayer)
        selectedLayer -= 1

        layers[selectedLayer].canvasView?.showToolPicker()
        
    }
    
    func MergeLayers() {
        selectedLayer = 0;
        
        var layerArr = layerModel.layers
        
        if(layerArr.count == 1) {
            return;
        }
        
        let masterLayer = PKCanvasView()
        
        //reverse so we keep layer integrety when appending drawings
        layerArr.reverse()
        
        for layer in layerArr {
            masterLayer.drawing.append(layer.canvasView!.pkCanvasView.drawing)
        }
        
        //reverse back to normal order, remove everything but last
        layerArr.reverse()
        layerArr[0].canvasView!.pkCanvasView.drawing = masterLayer.drawing
        layerModel.layers.removeLast(layerArr.count - 1)

        //re-show tool picker since layers are cleaned up
        layerArr[0].canvasView!.showToolPicker()
    }
    
    func SelectLayer(index: Int) {
        self.selectedLayer = index
    }
    
    
    
    func GetCurrentLayer() -> Layer {
        return layerModel.getLayers()[self.selectedLayer]
    }
}
