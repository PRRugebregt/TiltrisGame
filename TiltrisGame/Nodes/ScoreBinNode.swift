//
//  ScoreBinNode.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 05/02/2025.
//

import Foundation
import SpriteKit

enum Side {
    case left
    case right
}

/// This is the scoreBin node, that displays which shape (and at what angle) you should drop in the bin to score points
class ScoreBinNode: SKNode {
    let scoreBin: ScoreBin
    let side: Side
    let scoreBinWidth: CGFloat = 120
    private let strokeWidth: CGFloat = 10
    
    init(scoreBin: ScoreBin, side: Side) {
        self.scoreBin = scoreBin
        self.side = side
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // Create a tetris shape
        let tetrisShape = TetrisBlockNode(
            tetrisShape: scoreBin.shape,
            angle: scoreBin.angle,
            hasPhysicsBody: false
        )

        let tetrisShapeSize = tetrisShape.calculateAccumulatedFrame()

        tetrisShape.position = CGPoint(
            x: calculateXPosition(tetrisShapeSize: tetrisShapeSize),
            y: scoreBinWidth / 2 + (strokeWidth / 2)
        )
        tetrisShape.alpha = 0.4
        
        let bin = BinNode(
            rect: CGRect(x: 0, y: 0, width: strokeWidth, height: scoreBinWidth),
            scoreBin: scoreBin,
            side: side
        )
                
        self.addChild(bin)
        self.addChild(tetrisShape)
    }
    
    private func calculateXPosition(tetrisShapeSize: CGRect) -> CGFloat {
        if side == .left {
            return tetrisShapeSize.width / 2 + 20
        } else {
            return -tetrisShapeSize.width / 2 - 20
        }
    }
}
