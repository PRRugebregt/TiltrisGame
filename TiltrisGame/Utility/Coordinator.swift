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
    case settings
}

protocol NavigationProtocol {
    func navigate(to: Destination)
}

class Coordinator: ObservableObject, NavigationProtocol {
    @Published var currentDestination: Destination = .home
    var path: [Destination] = []
    
    func navigate(to destination: Destination) {
        currentDestination = destination
        path.append(currentDestination)
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
            InstructionView()
        case .game:
            GameView()
        case .settings:
            InstructionView()
        }
    }
}
