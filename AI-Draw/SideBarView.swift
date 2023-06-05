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
    
    var imgService : StableDiffusionService
    
    init(layerModel: LayersModel) {
        self.layerModel = layerModel
        self.imgService = StableDiffusionService()
    }
    
    var body: some View {
        VStack {
            //let p = print("Side View Reloaded")
            Text("Layers")
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(layerModel.layers, id: \.id) { layer in
                        Button {
                            // Clicking on itself will unselect and goto first instead
                            if self.selectedLayer == layer.layerIndex {
                                self.selectedLayer = 0
                            } else {
                                self.selectedLayer = layer.layerIndex
                            }
                            
                        } label: {
                            let isSelected = layer === self.layerModel.getLayers()[self.selectedLayer]
                            layer.thumbnail
                                .resizable()
                                .frame(width:110, height: 90)
                                .background(.white)
                                .border(isSelected ? .red : .blue, width: isSelected ? 3 : 1)
                        }

                        .onDrag({
                            SideBarView.draggedLayer = layer
                            print("Dragged", SideBarView.draggedLayer?.layerIndex ?? -1, layer.layerIndex)
                            
                            return NSItemProvider()
                        })
                        .onDrop(of: [UTType.text], delegate: LayerDropDelegate(item: layer, layersModel: self.layerModel))
                        
                    }
                    
                    Button {
                        withAnimation(.default) {
                            self.AddLayer()
                        }
                    } label :{
                        Image(systemName: "plus.app")
                            .resizable()
                            .frame(width:30, height: 30)
                    }
                    
                }
                .padding(5)
            }.background(.brown)
            .frame(height: 500)
            
            DeleteLayerButton {
                withAnimation(.default) {
                    self.DeleteLayer()
                }
            }
            
            MergeLayersButton {
                withAnimation(.default) {
                    self.MergeLayers()
                }
            }
            
            GenerateButton {
                withAnimation(.default) {
                    self.AddLayer()

                    let img = self.imgService.GenerateImage(prompt: "Old Male",
                     callback: {img in
                        print("REceived: ", img)
                        DispatchQueue.main.sync {
                            self.SetImgLayer(img: img)
                        }
                        }
                    )
                    //self.imgService.GenerateImage(prompt: "Old Male")
                }
            }
            
            Spacer()
        }
    }
}

extension SideBarView {
    
    func GetView() -> some View {
        return  body
    }
    
    func AddLayer() {
        selectedLayer = layerModel.getLayers().count
        layerModel.AddLayer()
    }
    
    func SetImgLayer(img: UIImage?) {
        
        if(img == nil) {
            return
        }
        print("Got Img!", img)
        let layers = layerModel.layers
        let newImg = img!
        print("NEW VIEW 0")
        let newImgView = UIImageView(image: newImg)
        print("NEW VIEW")

        let subview = self.GetCurrentLayer().canvasView!.pkCanvasView.subviews[0]
        subview.addSubview(newImgView)
        subview.sendSubviewToBack(newImgView)

        //subview.bringSubviewToFront(newImgView)
        newImgView.becomeFirstResponder()
        print("Added Img ", selectedLayer)
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
