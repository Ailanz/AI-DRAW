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
    @Published var layers : [Layer] = [Layer(layer: 0, thumbnail: Image(uiImage: UIImage()))]
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
            ForEach(layers) { layer in
                
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
                        .border(layer === self.layers[self.selectedLayer] ? .red : .blue)
                        
                    
                    
                }
                .onDrag({
                    SideBarView.draggedLayer = layer
                    print("Dragged", SideBarView.draggedLayer?.layerIndex, layer.layerIndex)

                    return NSItemProvider()
                })
                .onDrop(of: [UTType.text], delegate: TestDelegate(item: layer, items: self.layers))
            
                
            }
            
            Button("Add Layer") {
                self.AddLayer()
            }
        }
    }
}
struct TestDelegate : DropDelegate {
    let item : Layer
    @State var items : [Layer]
    
    init(item: Layer, items: [Layer]) {
        self.item = item
        self.items = items
        //print("Delegate Created:", SideBarView.draggedLayer?.layerIndex , item.layerIndex, items.count)
    }

    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("Drop entered", SideBarView.draggedLayer?.layerIndex , item.layerIndex, items.count)
        guard let draggedItem = SideBarView.draggedLayer else {
            return
        }
        if item == nil {
            return
        }
        
        if draggedItem !== item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            print("From : To", from, to)
            
            withAnimation(.default) {
                var tmp = items[from].layerIndex
                items[from].layerIndex = items[to].layerIndex
                items[to].layerIndex = tmp
                
                items.sort { l1, l2 in
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
        uiView.addSubview(layers[0].canvasView!.pkCanvasView)
    }
    
    func AddLayer() {
        selectedLayer = layers.count
        let newLayer  = Layer(layer: selectedLayer, thumbnail: Image(uiImage: UIImage()))
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
