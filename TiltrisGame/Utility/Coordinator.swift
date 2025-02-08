//
//  Coordinator.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import Foundation
import SwiftUI

enum Destination: String {
    case home
    case instruction
    case game
}

enum SheetDestination: String {
    case settings
}

class Coordinator: ObservableObject {
    @Published var currentDestination: Destination = .home
    @Published var currentSheet: SheetDestination?
    var path: [Destination] = []
    
    func navigate(to destination: Destination) {
        currentDestination = destination
        path.append(currentDestination)
    }
    
    func sheet(destination: SheetDestination) {
        currentSheet = destination
    }
    
    func didPop() {
        path.removeLast()
        currentDestination = path.last ?? .home
    }
    
    @ViewBuilder
    func build(for destination: Destination) -> some View {
        switch destination {
        case .home:
            HomeView()
        case .instruction:
            InstructionView<InstructionViewModel>(viewModel: InstructionViewModel())
        case .game:
            GameView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    func buildSheet(for destination: SheetDestination) -> some View {
        switch destination {
        case .settings:
            SettingsView()
        }
    }
}
