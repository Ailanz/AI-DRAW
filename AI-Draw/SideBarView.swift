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
    @ObservedObject var layerModel = LayersModel()
    @Published var selectedLayer = 0
    @State var parentView: UIView = UIView()
    
    static var draggedLayer  : Layer?
    
//    init(_ draggedLayer: Binding<Layer?> = Binding.constant(Layer(layer: 0, thumbnail: Image(uiImage: UIImage())))) {
//        //self.layers[0].canvasView.onSaved = self.layers[0].UpdateImage
//        self.layers = [Layer(layer: 0, thumbnail: Image(uiImage: UIImage()))]
//        self._draggedLayer = draggedLayer
//    }
    
    var body: some View {

        LazyVStack {
            ForEach(layerModel.getLayers()) { layer in
                
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
                    print("Dragged", SideBarView.draggedLayer?.layerIndex, layer.layerIndex)

                    return NSItemProvider()
                })
                .onDrop(of: [UTType.text], delegate: TestDelegate(item: layer, layersModel: self.layerModel))
            
                
            }
            
            Button("Add Layer") {
                self.AddLayer()
            }
        }
    }
}
struct TestDelegate : DropDelegate {
    let item : Layer
    var layersModel : LayersModel
    
    init(item: Layer, layersModel: LayersModel) {
        self.item = item
        self.layersModel = layersModel
    }

    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("Drop entered", SideBarView.draggedLayer?.layerIndex , item.layerIndex, layersModel.getLayers().count)
        guard let draggedItem = SideBarView.draggedLayer else {
            return
        }
        if item == nil {
            return
        }
        
        if draggedItem !== item {
            let from = layersModel.getLayers().firstIndex(of: draggedItem)!
            let to = layersModel.getLayers().firstIndex(of: item)!
            print("From : To", from, to)
            
            withAnimation(.default) {
                var tmp = layersModel.getLayers()[from].layerIndex
                layersModel.getLayers()[from].layerIndex = layersModel.getLayers()[to].layerIndex
                layersModel.getLayers()[to].layerIndex = tmp

                layersModel.layers.sort { l1, l2 in
                    return l1.layerIndex < l2.layerIndex
                }
                print("Swapped")
                //self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
    
}

struct MyDropDelegate : DropDelegate {
    let item : Layer
    @Binding var items : [Layer]
    @Binding var draggedItem : Layer?
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }
        if draggedItem !== item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
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
        uiView.addSubview(layerModel.getLayers()[0].canvasView!.pkCanvasView)
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
