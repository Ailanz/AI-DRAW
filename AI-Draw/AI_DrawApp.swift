//
//  AI_DrawApp.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-16.
//

import SwiftUI
import PencilKit

@main
struct AI_DrawApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            let canvasView = PKCanvasView()
            DrawingView(canvasView: canvasView, sideBarView: SideBarView(canvasView: canvasView))        }
    }
}
