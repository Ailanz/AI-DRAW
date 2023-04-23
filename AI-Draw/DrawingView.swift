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
    
    @State private var canvasView : PKCanvasView
    @ObservedObject private var sideBarView : SideBarView
    
    init(canvasView: PKCanvasView, sideBarView: SideBarView) {
        self.canvasView = canvasView
        self.sideBarView = sideBarView
    }
    
    
    var body: some View {
        HStack (alignment: .top) {
            CanvasView(onSaved: {
                var drawing = canvasView.drawing
                print("Saved:")
                print("Strokes: ", drawing.strokes.count)
                let lastStroke = drawing.strokes.last
                sideBarView.GetCurrentLayer().AddStroke(stroke: lastStroke!)
                sideBarView.GetCurrentLayer().UpdateImage(bounds: canvasView.bounds)
                
                //Experiment
                drawing.strokes.removeAll()
                //End Experiment
                
                print("--Strokes: ", drawing.strokes.count)

            }, canvasView: $canvasView)
            .border(.black)
            .padding()

            sideBarView.GetView()
                .padding()

        }.background(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let canvasView = PKCanvasView()
        DrawingView(canvasView: canvasView, sideBarView: SideBarView(canvasView: canvasView))
    }
}
