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
    @State var isSheetPresented = false
    
    init(coordinator: Coordinator = Coordinator(), selectedView: String? = nil, isSheetPresented: Bool = false) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.selectedView = selectedView
        self.isSheetPresented = isSheetPresented
        // Customize navbar
        UINavigationBar.appearance().backgroundColor = .black
    }
    
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
            .sheet(
                isPresented: $isSheetPresented,
                onDismiss: {
                    coordinator.currentSheet = nil
                }, content: {
                    coordinator.buildSheet(for: coordinator.currentSheet ?? .settings)
            })
        }
        .onChange(of: coordinator.currentSheet) { currentSheet in
            isSheetPresented = currentSheet != nil
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
