//
//  RootCoordinatorView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI

struct RootCoordinatorView: View {
    @StateObject var coordinator: Coordinator
    @State var isSheetPresented = false
    
    init() {
        self._coordinator = StateObject(wrappedValue: Coordinator())
        // Customize navbar
        UINavigationBar.appearance().backgroundColor = .black
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                // Home view
                HomeView()
                    .environmentObject(coordinator)
                    .navigationDestination(for: Destination.self) { screen in
                        coordinator.build(for: screen)
                            .environmentObject(coordinator)
                    }
            }
            .sheet(
                isPresented: $isSheetPresented,
                onDismiss: {
                    coordinator.currentSheet = nil
                }, content: {
                    coordinator.buildSheet(for: coordinator.currentSheet ?? .settings)
            })
        }
    }
}

#Preview {
    RootCoordinatorView()
}
