//
//  SKPhysicsContact + extensions.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 01/02/2025.
//

import Foundation
import SpriteKit

extension SKPhysicsContact {
    func isBlockOrBoundsCollision(currentBlockPosition: CGPoint?) -> Bool {
        guard let currentBlockPosition else { return false }
        return isBlockOnlyCollision() || isBlockBoundsCollision() && currentBlockPosition.y < 100
    }
    
    private func isBlockBoundsCollision() -> Bool {
        return (PhysicsCategory.isBlock(bodyA.categoryBitMask) && PhysicsCategory.isBounds(bodyB.categoryBitMask)) || (PhysicsCategory.isBounds(bodyA.categoryBitMask) && PhysicsCategory.isBlock(bodyB.categoryBitMask))
    }
    
    private func isBlockOnlyCollision() -> Bool {
        (PhysicsCategory.isBlock(bodyA.categoryBitMask) && PhysicsCategory.isBlock(bodyB.categoryBitMask))
    }
}
