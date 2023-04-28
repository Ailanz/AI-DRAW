//
//  DeleteLayerButton.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-04-27.
//

import SwiftUI

struct DeleteLayerButton: View {
    
    var onPress : () -> Void
    @State private var showingAlert = false

    
    init(onPress: @escaping () -> Void) {
        self.onPress = onPress
    }
    
    var body: some View {
        Button("Delete Layer".padding(toLength: 13, withPad: " ", startingAt: 0)) {
            showingAlert = true
        }
        .alert(isPresented:$showingAlert) {
                   Alert(
                       title: Text("Are you sure you want to delete this layer?"),
                       message: Text("There cannot be undone"),
                       primaryButton: .destructive(Text("Delete")) {
                           onPress()
                       },
                       secondaryButton: .cancel()
                   )
               }
        
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
}
