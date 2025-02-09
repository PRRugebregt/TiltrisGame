//
//  SettingsView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI

protocol Options: Identifiable, RawRepresentable, CaseIterable where RawValue == String {
    //func rawValue() -> String
}

enum SettingsItem: String {
    case difficulty
    case colorTheme
        
    enum ColorOptions: String, Options {
        //case red
        case yellow
        //case blue
        
        var id: String {
            rawValue
        }
        
        func color() -> Color {
            switch self {
//            case .red:
//                Color.red
            case .yellow:
                Color.yellow
//            case .blue:
//                Color.blue
            }
        }
    }
    
    enum DifficultyOptions: String, Options {
        case easy
        case medium
        case hard
        
        var id: String {
            rawValue
        }
    }
    
    func title() -> String {
        return rawValue
    }
    
    func options() -> [any Options] {
        switch self {
        case .difficulty:
            return ColorOptions.allCases
        case .colorTheme:
            return DifficultyOptions.allCases
        }
    }
}

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

struct SettingsItemView<T: Options>: View {
    let settingsItem: SettingsItem
    var options: [T]
    @Binding var selectedItem: T?
    
    var body: some View {
        HStack {
            Text(settingsItem.title())
                .font(.subheadline)
                .foregroundStyle(.white)
            Spacer()
            Menu("Choose") {
                ForEach(options) { option in
                    Button(option.rawValue) {
                        selectedItem = option
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    SettingsView(selectedDifficulty: .easy)
}
