//
//  ScoreBinNode.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 05/02/2025.
//

import Foundation
import SpriteKit

class TheBin: SKShapeNode {
    let scoreBin: ScoreBin
    
    init(rect: CGRect, scoreBin: ScoreBin) {
        self.scoreBin = scoreBin
        super.init()
        self.path = CGPath(rect: rect, transform: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        fillColor = .blue
        lineWidth = 2
        strokeColor = .black
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 90, height: 10))
        physicsBody?.collisionBitMask = PhysicsCategory.block.rawValue
        physicsBody?.categoryBitMask = PhysicsCategory.scoreBin.rawValue
        physicsBody?.affectedByGravity = false
        physicsBody?.angularDamping = 1
        physicsBody?.linearDamping = 1000
        physicsBody?.isDynamic = false
    }
}

class ScoreBinNode: SKNode {
    let scoreBin: ScoreBin
    
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
            angle: Angle(rawValue: scoreBin.rotation) ?? .zero,
            hasPhysicsBody: false
        )

        tetrisShape.zRotation = tetrisShape.angle.rawValue
        let tetrisShapeSize = tetrisShape.calculateAccumulatedFrame()

        tetrisShape.position = CGPoint(
            x: 45, // 3 blocksizes (of 30) / 2
            y: tetrisShapeSize.height / 2 + 20
        )
        tetrisShape.alpha = 0.4
        
        let bin = TheBin(rect: CGRect(x: 0, y: 0, width: 100, height: 10), scoreBin: scoreBin)
        let leftSide = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 5, height: 50))
        leftSide.physicsBody = standardPhysicsBody(frame: leftSide.frame)
        leftSide.fillColor = .blue
        let rightSide = SKShapeNode(rect: CGRect(x: 100, y: 0, width: 5, height: 50))
        rightSide.physicsBody = standardPhysicsBody(frame: rightSide.frame)
        rightSide.fillColor = .blue
        bin.addChild(leftSide)
        bin.addChild(rightSide)
        
        self.addChild(bin)
        self.addChild(tetrisShape)
    }
    
    private func standardPhysicsBody(frame: CGRect) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: frame, transform: nil))
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.angularDamping = 1
        physicsBody.linearDamping = 1000
        return physicsBody
    }
}
