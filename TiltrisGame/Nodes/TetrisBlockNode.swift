//
//  TetrisShapeNode.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import UIKit
import SpriteKit

class TetrisBlockNode: SKNode {
    let shape: TetrisShape
    var angle: Angle = .zero {
        didSet {
            zRotation = angle.rawValue
        }
    }
    
    private var blockWidth: CGFloat
    private lazy var blockSize = CGSize(width: blockWidth, height: blockWidth)
    private let hasPhysicsBody: Bool // Boolean whether this shape needs to be affected by gravity and collision
    
    init(
        tetrisShape: TetrisShape,
        angle: Angle = .zero,
        hasPhysicsBody: Bool,
        blockWidth: CGFloat = 20
    ) {
        self.shape = tetrisShape
        self.angle = angle
        self.hasPhysicsBody = hasPhysicsBody
        self.blockWidth = blockWidth
        super.init()
        // Setup the block
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // Set the correct rotation for the angle
        zRotation = angle.rawValue

        let blockPositions = shape.calculatePositions(with: blockSize.width)
        addBlocksToBlockNode(positions: blockPositions)
        if hasPhysicsBody {
            configurePhysicsBody()
        }
    }
    
    private func configurePhysicsBody() {
        // Configure physics body of the shape
        physicsBody?.affectedByGravity = true
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = true
        physicsBody?.angularDamping = 1
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
        if hasPhysicsBody {
            self.physicsBody = SKPhysicsBody(bodies: physicsBodies)
        }
    }
    
    /// Returns the animation when a block hits one of the bins
    func finalActionAnimation(_ isCorrect: Bool) -> SKAction {
        let fadeAction = SKAction.fadeOut(withDuration: 2)
        let colorAction = SKAction.customAction(withDuration: 2) { node, float in
            for child in node.children {
                if let child = child as? SKSpriteNode {
                    child.run(SKAction.colorize(with: isCorrect ? .green : .red, colorBlendFactor: 1, duration: 2))
                }
            }
        }
        let combinedAnimation = SKAction.group([fadeAction, colorAction])
        return combinedAnimation
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
