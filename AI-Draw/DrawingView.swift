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
    @State private var canvasView = PKCanvasView()

    var body: some View {
        VStack {
            CanvasView(canvasView: $canvasView)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
