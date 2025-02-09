//
//  TetrisShapeView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import Foundation
import SwiftUI
import SpriteKit

/// A tetris shape SwiftUI view representation
struct TetrisShapeView: View {
    @State private var tetrisShapeScene: SKScene
    @State private var block: TetrisBlockNode
        
    init(screenWidth: CGFloat, blockWidth: CGFloat, shape: TetrisShape = .tShape, angle: Angle = .oneEighty) {
        let tetrisShapeScene = SKScene()
        tetrisShapeScene.scaleMode = .resizeFill
        let tetrisBlock = TetrisBlockNode(tetrisShape: shape, angle: angle, hasPhysicsBody: false, blockWidth: blockWidth)
        self.block = tetrisBlock
        tetrisBlock.position = CGPoint(x: screenWidth / 2, y: blockWidth * 2)
        tetrisShapeScene.addChild(tetrisBlock)
        
        tetrisShapeScene.backgroundColor = .clear

        self.tetrisShapeScene = tetrisShapeScene
    }
    
    var body: some View {
        SpriteView(scene: tetrisShapeScene, options: .allowsTransparency)
            .ignoresSafeArea()
            .background(Color.clear)
            .onDisappear {
                block.removeAllActions()
                block.removeFromParent()
                tetrisShapeScene.isPaused = true
                tetrisShapeScene.view?.presentScene(nil) // ✅ Disconnect from `SpriteView`
                tetrisShapeScene.removeAllActions()
                tetrisShapeScene.removeAllChildren()
            }
    }
}
