//
//  RootCoordinatorView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI

struct RootCoordinatorView: View {
    @StateObject var coordinator = Coordinator()
    @State var selectedView: String?
    
    var body: some View {
        NavigationView {
            VStack {
                // Support for iOS < 16
                NavigationLink(
                    destination: coordinator.build(for: coordinator.currentDestination).environmentObject(coordinator),
                    tag: coordinator.currentDestination.rawValue,
                    selection: $selectedView,
                    label: { EmptyView() }
                )
                // Home view
                coordinator.build(for: .home)
                    .environmentObject(coordinator)
            }
        }
        .onChange(of: coordinator.currentDestination) {
            guard coordinator.currentDestination != .home else { return }
            selectedView = coordinator.currentDestination.rawValue
        }
    }
}

#Preview {
    RootCoordinatorView()
}
