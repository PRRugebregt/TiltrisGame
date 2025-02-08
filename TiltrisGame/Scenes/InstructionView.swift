//
//  InstructionView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 07/02/2025.
//

import SwiftUI

struct InstructionView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("hello")
        }
        .background(Color.blue)
        .ignoresSafeArea()
        .onDisappear {
            coordinator.didPop()
        }
    }
}

class InstructionViewModel: ObservableObject {
}

#Preview {
    InstructionView()
}
