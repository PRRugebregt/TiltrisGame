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

struct AppState {
    var colorTheme: Color = .yellow
    var difficulty: SettingsItem.DifficultyOptions = .easy
}

class Coordinator: ObservableObject {
    @Published var currentSheet: SheetDestination?
    @Published var path: NavigationPath = NavigationPath()
    @Published var appState: AppState = AppState()
    
    /// Updates navigationPath
    func navigate(to destination: Destination) {
        self.path.append(destination)
    }
    
    /// Updates sheet to present
    func sheet(destination: SheetDestination) {
        currentSheet = destination
    }
    
    /// Pop the last destination from path
    func didPop() {
        path.removeLast()
    }
    
    /// Change colorTheme App state
    func changeColorTheme(to color: Color) {
        appState.colorTheme = color
    }
    
    /// Change difficulty App state
    func changeDifficulty(to difficulty: SettingsItem.DifficultyOptions) {
        appState.difficulty = difficulty
    }
    
    /// Build the views for navigation
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
    
    /// Build the sheets to display
    @ViewBuilder
    func buildSheet(for destination: SheetDestination) -> some View {
        switch destination {
        case .settings:
            SettingsView(selectedDifficulty: .easy)
        }
    }
}
