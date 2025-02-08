//
//  ScoreBinNode.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 05/02/2025.
//

import Foundation
import SpriteKit

/// This is the scoreBin node, that displays which shape (and at what angle) you should drop in the bin to score points
class ScoreBinNode: SKNode {
    let scoreBin: ScoreBin
    let scoreBinWidth: CGFloat = 100
    
    init(scoreBin: ScoreBin) {
        self.scoreBin = scoreBin
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
            x: scoreBinWidth / 2,
            y: tetrisShapeSize.height / 2 + 20
        )
        tetrisShape.alpha = 0.4
        
        let bin = BinNode(rect: CGRect(x: 0, y: 0, width: scoreBinWidth, height: 10), scoreBin: scoreBin)
        
        self.addChild(bin)
        self.addChild(tetrisShape)
    }
}
