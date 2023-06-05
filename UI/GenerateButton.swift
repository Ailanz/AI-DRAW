//
//  DeleteLayerButton.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-27.
//

import SwiftUI

struct GenerateButton: View {
    
    var onPress : () -> Void
    @State private var showingAlert = false

    
    init(onPress: @escaping () -> Void) {
        self.onPress = onPress
    }
    
    var body: some View {
        Button("Generate".padding(toLength: 17, withPad: " ", startingAt: 0)) {
            onPress()
        }
        
        .buttonStyle(.borderedProminent)
    }
}
