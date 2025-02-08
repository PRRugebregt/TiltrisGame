//
//  NodeConfigurator.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import Foundation
import SpriteKit

final class NodeConfigurator {
    /// Create a default square yellow block. Using SpriteNode to have the ability to animate color
    static func createDefaultBlock(position: CGPoint, blockSize: CGSize) -> SKSpriteNode {
        let block = SKSpriteNode(color: .yellow, size: blockSize)
        block.position = position
        let border = SKShapeNode(rectOf: blockSize)
        border.strokeColor = .gray
        border.lineWidth = 1
        block.addChild(border)
        return block
    }
    
    static func createDefaultPhysicsBody(position: CGPoint, blockSize: CGSize) -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(
            rectangleOf: blockSize,
            center: CGPoint(
                x: position.x,
                y: position.y
            )
        )
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = true
        return physicsBody
    }
    
    static func createGameBounds(size: CGSize, view: SKView) -> SKShapeNode {
        let lineWidth: CGFloat = 10
        let safeInsets = view.safeAreaInsets
        
        let gameFrame = CGRect(
            x: safeInsets.left + lineWidth,
            y: safeInsets.bottom + lineWidth,
            width: size.width - safeInsets.left - safeInsets.right - 2 * lineWidth,
            height: size.height - safeInsets.top - safeInsets.bottom - 2 * lineWidth
        )
    
        let gameBounds = SKShapeNode(rect: gameFrame)
        gameBounds.strokeColor = .white
        gameBounds.lineWidth = lineWidth
        
        gameBounds.physicsBody = SKPhysicsBody(edgeLoopFrom: gameFrame)
        gameBounds.physicsBody?.categoryBitMask = PhysicsCategory.bounds.rawValue
        gameBounds.physicsBody?.contactTestBitMask = PhysicsCategory.block.rawValue
        gameBounds.physicsBody?.collisionBitMask = PhysicsCategory.block.rawValue
        
        return gameBounds
    }
}
