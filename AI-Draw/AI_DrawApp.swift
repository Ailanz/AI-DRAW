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
            let layersModel = LayersModel()
            DrawingView(sideBarView: SideBarView(layerModel: layersModel), layerModel: layersModel)
        }
    }
}
