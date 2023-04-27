//
//  MainView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-16.
//

import SwiftUI
import UIKit
import PencilKit

struct DrawingView: View {
    
    @ObservedObject var sideBarView : SideBarView
    @ObservedObject var layerModel : LayersModel

    //@State var canvasView: PKCanvasView

    init(sideBarView: SideBarView, layerModel: LayersModel = LayersModel()) {
        self.sideBarView = sideBarView
        self.layerModel = layerModel
    }
    
    var body: some View {
        NavigationStack {
            HStack (alignment: .top) {
                ZStack {
                    
                    ForEach(layerModel.layers, id: \.id) { layer in
                        layer.canvasView
                        //.frame(width: 1000, height: 800)
                            .border(.black)
                            .padding(5.0)
                            .zIndex( sideBarView.selectedLayer == layer.layerIndex ? Double.infinity : Double(100 - layer.layerIndex))
                        
                    }
                }
                
                
                sideBarView.GetView()
                    .padding(5.0)
                
            }
            //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(.white)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let layersModel = LayersModel()
        DrawingView(sideBarView: SideBarView(layerModel: layersModel), layerModel: layersModel)
    }
}
