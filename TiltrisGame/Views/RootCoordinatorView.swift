//
//  RootCoordinatorView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI

struct RootCoordinatorView: View {
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        NavigationView {
            coordinator.build(for: .home)
                .navigationDestination(for: Destination.self) { screen in
                    coordinator.build(for: screen)
                        .environmentObject(coordinator)
                }
        }
    }
}

#Preview {
    RootCoordinatorView()
}
