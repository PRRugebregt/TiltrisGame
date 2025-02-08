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
}
