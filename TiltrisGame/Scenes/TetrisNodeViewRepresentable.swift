//
//  TetrisNodeViewRepresentable.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import Foundation
import SwiftUI
import SpriteKit

struct TetrisNodeViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = SKScene(size: CGSize(width: 100, height: 100))
        skView.frame.size = CGSize(width: 100, height: 100)
        let node = TetrisBlockNode(tetrisShape: .tShape, hasPhysicsBody: false)
        scene.backgroundColor = .clear
        skView.backgroundColor = .clear
        node.position = CGPoint(x: 50, y: 0)
        scene.addChild(node)
        skView.presentScene(scene)
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}
