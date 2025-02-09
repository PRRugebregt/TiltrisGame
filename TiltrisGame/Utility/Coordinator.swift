//
//  Coordinator.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import Foundation
import SwiftUI

enum Destination: String, Hashable, Equatable {
    case home
    case instruction
    case game
}

enum SheetDestination: String {
    case settings
}

class Coordinator: ObservableObject {
    @Published var currentSheet: SheetDestination?
    @Published var path: NavigationPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        print("### navigate to destination \(destination)")
        self.path.append(destination)
    }
    
    func sheet(destination: SheetDestination) {
        currentSheet = destination
    }
    
    func didPop() {
        path.removeLast()
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
