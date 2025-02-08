//
//  BinNode.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 06/02/2025.
//

import Foundation
import SpriteKit

/// This is the bin where which detects collisions with the falling TetrisShapes and checks whether it is the right piece
class BinNode: SKShapeNode {
    let scoreBin: ScoreBin
    private let width: CGFloat
    private let strokeWidth: CGFloat = 10
    private let sideHeight: CGFloat = 50
    
    init(rect: CGRect, scoreBin: ScoreBin) {
        self.scoreBin = scoreBin
        self.width = rect.width
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
        
        let leftSide = SKShapeNode(rect: CGRect(x: 0, y: 0, width: strokeWidth, height: sideHeight))
        leftSide.physicsBody = standardPhysicsBodyForSides(frame: leftSide.frame)
        leftSide.fillColor = .blue
        let rightSide = SKShapeNode(rect: CGRect(x: width, y: 0, width: strokeWidth, height: sideHeight))
        rightSide.physicsBody = standardPhysicsBodyForSides(frame: rightSide.frame)
        rightSide.fillColor = .blue
        addChild(leftSide)
        addChild(rightSide)
        setupPhysicsBody()
    }
    
    private func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: strokeWidth))
        physicsBody?.collisionBitMask = PhysicsCategory.block.rawValue
        physicsBody?.categoryBitMask = PhysicsCategory.scoreBin.rawValue
        physicsBody?.affectedByGravity = false
        physicsBody?.angularDamping = 1
        physicsBody?.linearDamping = 1000
        physicsBody?.isDynamic = false
    }
    
    private func standardPhysicsBodyForSides(frame: CGRect) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(polygonFrom: CGPath(rect: frame, transform: nil))
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.angularDamping = 1
        physicsBody.linearDamping = 1000
        return physicsBody
    }
}
