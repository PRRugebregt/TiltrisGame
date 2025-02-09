//
//  SettingsItemView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 09/02/2025.
//

import Foundation
import SwiftUI

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
