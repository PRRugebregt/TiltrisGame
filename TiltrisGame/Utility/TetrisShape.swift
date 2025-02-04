//
//  TetrisShape.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import Foundation

// How much "blocksizes" a block should be placed offcenter for X and Y axis
// For example if blockSize = 30pts: -1 means -1 * 30 = -30pts from center
typealias CenterOffsetXY = [(CGFloat, CGFloat)]

enum TetrisShape: CaseIterable {
    case square
    case tShape
    case lShape
    case long
    
    static let squareOffsets: CenterOffsetXY = [
        (-1, -1),
        (-1, 0),
        (0, -1),
        (0, 0)
    ]
    static let tShapeOffsets: CenterOffsetXY = [
        (-1.5, -1),
        (-0.5, -1),
        (0.5, -1),
        (-0.5, 0)
    ]
    static let lShapeOffsets: CenterOffsetXY = [
        (-1, -1),
        (-1, 0),
        (0, -1),
        (0, 0)
    ]
    static let longOffsets: CenterOffsetXY = [
        (-0.5, -2),
        (-0.5, -1),
        (-0.5, 0),
        (-0.5, 1)
    ]
    
    func calculatePositions(with blockSize: CGFloat) -> [CGPoint] {
        switch self {
        case .square:
            return Self.squareOffsets.map(
                { CGPoint(x: $0.0 * blockSize, y: $0.1 * blockSize) }
            )
        case .tShape:
            return Self.tShapeOffsets.map(
                { CGPoint(x: $0.0 * blockSize, y: $0.1 * blockSize) }
            )
        case .lShape:
            return Self.lShapeOffsets.map(
                { CGPoint(x: $0.0 * blockSize, y: $0.1 * blockSize) }
            )
        case .long:
            return Self.longOffsets.map(
                { CGPoint(x: $0.0 * blockSize, y: $0.1 * blockSize) }
            )
        }
    }
}
