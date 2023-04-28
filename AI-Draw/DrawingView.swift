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
            HStack (alignment: .top, spacing: 0) {
                ZStack {
                    ForEach(layerModel.layers, id: \.id) { layer in
                        layer.canvasView
                            .background(.clear)
                            .padding(0)
                            .zIndex( sideBarView.selectedLayer == layer.layerIndex ? Double.infinity : Double(100 - layer.layerIndex))
                    }
                }.padding(.top, 25)

                sideBarView.GetView().background(Color.brown)
                
            }
            .frame(height: UIScreen.main.bounds.height)

            .toolbar {
                ToolbarItem(placement: .automatic) {
                    
                    Text("Test")
                }
            }
            .navigationTitle("AI-Draw")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar, .bottomBar)
            .toolbarBackground(.visible, for: .navigationBar, .bottomBar)

            .background(.gray)
        }
       .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let layersModel = LayersModel()
        DrawingView(sideBarView: SideBarView(layerModel: layersModel), layerModel: layersModel)
    }
}
