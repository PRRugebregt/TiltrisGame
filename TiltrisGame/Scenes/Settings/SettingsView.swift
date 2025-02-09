//
//  SettingsView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State var selectedColor: SettingsItem.ColorOptions?
    @State var selectedDifficulty: SettingsItem.DifficultyOptions?
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .ignoresSafeArea()
            VStack {
                Text("Settings")
                    .font(.title)
                    .foregroundStyle(.yellow)
                    .padding()
                Spacer()
                SettingsItemView(
                    settingsItem: .colorTheme,
                    options: SettingsItem.ColorOptions.allCases,
                    selectedItem: $selectedColor
                )
                SettingsItemView(
                    settingsItem: .difficulty,
                    options: SettingsItem.DifficultyOptions.allCases,
                    selectedItem: $selectedDifficulty
                )
                Spacer()
            }
        }
        .onChange(of: selectedColor) {
            guard let color = selectedColor?.color() else { return }
            coordinator.changeColorTheme(to: color)
        }
        .onChange(of: selectedDifficulty) {
            guard let selectedDifficulty else { return }
            coordinator.changeDifficulty(to: selectedDifficulty)
        }
    }
}

#Preview {
    SettingsView(selectedDifficulty: .easy)
}
