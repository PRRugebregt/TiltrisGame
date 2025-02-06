//
//  PhysicsCategory.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 02/02/2025.
//

import Foundation

enum PhysicsCategory: UInt32 {
    case none = 0
    case block = 1
    case bounds = 2
    case scoreBin = 3
    
    static func isBlock(_ rawValue: UInt32) -> Bool {
        return PhysicsCategory(rawValue: rawValue) == .block
    }
    
    static func isBounds(_ rawValue: UInt32) -> Bool {
        return PhysicsCategory(rawValue: rawValue) == .bounds
    }
    
    static func isScoreBin(_ rawValue: UInt32) -> Bool {
        return PhysicsCategory(rawValue: rawValue) == .scoreBin
    }
}
