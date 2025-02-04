//
//  TetrisShapeNode.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import UIKit
import SpriteKit

class TetrisBlockNode: SKNode {
    private let shape: TetrisShape
    private lazy var blockWidth = UIScreen.main.bounds.width / 10
    private lazy var blockSize = CGSize(width: blockWidth, height: blockWidth)

    init(tetrisShape: TetrisShape) {
        self.shape = tetrisShape
        super.init()
        // Setup the block
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let blockPositions = shape.calculatePositions(with: blockSize.width)
        addBlocksToBlockNode(positions: blockPositions)
        configurePhysicsBody()
    }
    
    private func configurePhysicsBody() {
        // Configure physics body of the shape
        physicsBody?.affectedByGravity = true
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = true
        physicsBody?.restitution = 0.0
        physicsBody?.friction = 0.5
        physicsBody?.linearDamping = 0.3
        
        physicsBody?.categoryBitMask = PhysicsCategory.block.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.bounds.rawValue | PhysicsCategory.block.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.bounds.rawValue | PhysicsCategory.block.rawValue
    }
    
    /// Adding the individual blocks to the block node
    private func addBlocksToBlockNode(positions: [CGPoint]) {
        var physicsBodies: [SKPhysicsBody] = []

        for position in positions {
            // Create the block with the correct position
            let block = NodeConfigurator.createDefaultBlock(
                position: position,
                blockSize: blockSize
            )
            // Create the physicsBody and add it to the array
            physicsBodies.append(
                NodeConfigurator.createDefaultPhysicsBody(
                    position: position,
                    blockSize: blockSize
                )
            )
            // Add block as a childnode
            self.addChild(block)
        }
        
        // Define the physicsbody of the tetrisShape by combining the physicsbodies of individual blocks
        self.physicsBody = SKPhysicsBody(bodies: physicsBodies)
    }
}

extension TetrisBlockNode {
    /// Just here for reference. Old way of calculating positions of blocks
    /*
     Positions for blocks to create tetris blocks.
     B3 is anchor position
     | A4 | B4 | C4 |
     | A3 | B3 | C3 |
     | A2 | B2 | C2 |
     | A1 | B1 | C1 |
     */
    
    private enum Position {
        case a(_ row: Int)
        case b(_ row: Int)
        case c(_ row: Int)
        
        func calculatePosition(
            with blockSize: CGFloat
        ) -> CGPoint {
            let x: CGFloat
            let y: CGFloat
            
            switch self {
            case .a(let row):
                x = -blockSize
                y = calculateYPosition(row, blockSize: blockSize)
            case .b(let row):
                x = 0
                y = calculateYPosition(row, blockSize: blockSize)
            case .c(let row):
                x = blockSize
                y = calculateYPosition(row, blockSize: blockSize)
            }
            return CGPoint(x: x, y: y)
        }
        
        private func calculateYPosition(
            _ row: Int,
            blockSize: CGFloat
        ) -> CGFloat {
            CGFloat(row - 1) * blockSize
        }
    }
}
