//
//  SettingsItem.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 09/02/2025.
//

import Foundation
import SwiftUI

protocol Options: Identifiable, RawRepresentable, CaseIterable where RawValue == String {}

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
