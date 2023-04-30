//
//  CanvasView.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-16.
//

import SwiftUI
import UIKit
import PencilKit

struct CanvasView {
    var onSaved: () -> Void

    @State static var toolPicker = PKToolPicker()
    @State var pkCanvasView: PKCanvasView
    @State var thumbnail: Image
    
    init(onSaved: @escaping () -> Void, pkCanvasView: PKCanvasView, thumbnail: Image) {
        self.onSaved = onSaved
        self.pkCanvasView = pkCanvasView
        self.thumbnail = thumbnail
  
        //TESTING ADD IMAGE TO VIEW
//        let imageView = UIImageView(image: UIImage(named: "img1"))
//        let contentView = self.pkCanvasView.subviews[0]
//        contentView.addSubview(imageView)
//        contentView.sendSubviewToBack(imageView)
//        contentView.bringSubviewToFront(imageView)
    }
    
    
    func showToolPicker() {
        CanvasView.toolPicker.setVisible(true, forFirstResponder: pkCanvasView)
        CanvasView.toolPicker.addObserver(pkCanvasView)
        pkCanvasView.becomeFirstResponder()
    }
}

extension CanvasView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        pkCanvasView.tool = PKInkingTool(.pen, color: .gray, width: 10)
        pkCanvasView.drawingPolicy = .anyInput
        pkCanvasView.delegate = context.coordinator
        showToolPicker()
        
        pkCanvasView.backgroundColor = UIColor.clear
        pkCanvasView.isOpaque = true
        return pkCanvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $pkCanvasView, onSaved: onSaved)
    }
    
}

class Coordinator: NSObject {
    var canvasView: Binding<PKCanvasView>
    var onSaved: () -> Void
    
    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvasView = canvasView
        self.onSaved = onSaved
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}
