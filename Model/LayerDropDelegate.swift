//
//  LayerDropDelegate.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-25.
//

import Foundation
import SwiftUI

struct LayerDropDelegate : DropDelegate {
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
            }
        }
    }
    
}
