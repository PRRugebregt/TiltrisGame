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
    private let height: CGFloat
    private let side: Side

    private let strokeWidth: CGFloat = 10
    private let sideLength: CGFloat = 50
    
    init(rect: CGRect, scoreBin: ScoreBin, side: Side) {
        self.scoreBin = scoreBin
        self.height = rect.height
        self.side = side
        
        super.init()
        
        path = CGPath(rect: rect, transform: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        fillColor = .blue
        lineWidth = 2
        strokeColor = .black
        // Create the two side arms of the bin.
        // Since the bin is rotated on the screen, we call them top and bottom Sides
        let topSide = createSideNode(isTopSide: true)
        let bottomSide = createSideNode(isTopSide: false)
        
        addChild(topSide)
        addChild(bottomSide)
        
        setupPhysicsBody()
    }
    
    private func createSideNode(isTopSide: Bool) -> SKShapeNode {
        let halfStrokeWidth = strokeWidth / 2
        // Determine where to position the side nodes. When its on the left of the screen x = 0
        // When it is on the right of the screen x should be the length of a sideNode
        let side = SKShapeNode(
            rect: CGRect(
                x: side == .left ? 0 : -sideLength + strokeWidth,
                y: isTopSide ? 0 : height - halfStrokeWidth,
                width: sideLength,
                height: strokeWidth
            )
        )
        side.physicsBody = standardPhysicsBodyForSides(frame: side.frame)
        side.fillColor = .blue
        return side
    }
    
    private func setupPhysicsBody() {
        guard let path else { return }
        physicsBody = SKPhysicsBody(polygonFrom: path)
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
