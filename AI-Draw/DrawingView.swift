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
    
    @StateObject var sideBarView : SideBarView = SideBarView()
    @State var canvasView: PKCanvasView
    
    init(sideBarView: SideBarView, _ canvasView: PKCanvasView) {
        //self.sideBarView = sideBarView
        self.canvasView = canvasView
        sideBarView.RegisterParentView(uiView: canvasView)
    }
    
    var body: some View {
        HStack (alignment: .top) {
            ZStack {
                
                ForEach(sideBarView.layers) { layer in
                    layer.canvasView!
                        .frame(width: 1000, height: 800)
                        .border(.black)
//                        .zIndex(Double(100 - layer.layerIndex))
                        .zIndex( sideBarView.selectedLayer == layer.layerIndex ? Double.infinity : Double(100 - layer.layerIndex))
                    
                }
            }
//            CanvasView(onSaved: {
//
//
//            }, canvasView: canvasView)
//            .border(.black)
//            .padding()

            sideBarView.GetView()
                .padding()

        }.background(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(sideBarView: SideBarView(), PKCanvasView())
    }
}
