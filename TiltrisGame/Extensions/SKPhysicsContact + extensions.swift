//
//  SKPhysicsContact + extensions.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import Foundation
import SpriteKit

extension SKPhysicsContact {
    func isBlockOrBoundsCollision(currentBlock: SKNode?) -> Bool {
        guard let currentBlock else { return false }
        return isBlockOnlyCollision() || isBlockBoundsCollision() && currentBlock.position.y < (currentBlock.calculateAccumulatedFrame().size.height + 20)
    }
    
    private func isBlockBoundsCollision() -> Bool {
        return (PhysicsCategory.isBlock(bodyA.categoryBitMask) && PhysicsCategory.isBounds(bodyB.categoryBitMask)) || (PhysicsCategory.isBounds(bodyA.categoryBitMask) && PhysicsCategory.isBlock(bodyB.categoryBitMask))
    }
    
    func isBlockOnlyCollision() -> Bool {
        (PhysicsCategory.isBlock(bodyA.categoryBitMask) && PhysicsCategory.isBlock(bodyB.categoryBitMask))
    }
}
