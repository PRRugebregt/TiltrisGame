//
//  TetrisShape.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import Foundation

// How much "blocksizes" a block should be placed offcenter for X and Y axis
// For example if blockSize = 30pts: -1 means -1 * 30 = -30pts from center
typealias CenterOffsetXY = [(x: CGFloat, y: CGFloat)]

enum TetrisShape: CaseIterable {
    case square
    case tShape
    case lShape
    case long
    
    static let squareOffsets: CenterOffsetXY = [
        (-0.5, -0.5),
        (-0.5, 0.5),
        (0.5, -0.5),
        (0.5, 0.5)
    ]
    static let tShapeOffsets: CenterOffsetXY = [
        (-1, -0.5),
        (-0, -0.5),
        (1, -0.5),
        (0, 0.5)
    ]
    static let lShapeOffsets: CenterOffsetXY = [
        (-1, -0.5),
        (0, -0.5),
        (1, -0.5),
        (1, 0.5)
    ]
    static let longOffsets: CenterOffsetXY = [
        (0, -1.5),
        (0, -0.5),
        (0, 0.5),
        (0, 1.5)
    ]
    
    func calculatePositions(with blockSize: CGFloat) -> [CGPoint] {
        switch self {
        case .square:
            return Self.squareOffsets.map(
                { CGPoint(x: $0.x * blockSize, y: $0.y * blockSize) }
            )
        case .tShape:
            return Self.tShapeOffsets.map(
                { CGPoint(x: $0.x * blockSize, y: $0.y * blockSize) }
            )
        case .lShape:
            return Self.lShapeOffsets.map(
                { CGPoint(x: $0.x * blockSize, y: $0.y * blockSize) }
            )
        case .long:
            return Self.longOffsets.map(
                { CGPoint(x: $0.x * blockSize, y: $0.y * blockSize) }
            )
        }
    }
    
    func calculateScore() -> Int {
        switch self {
        case .square:
            return 1
        case .tShape, .lShape:
            return 3
        case .long:
            return 2
        }
    }
}
