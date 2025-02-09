//
//  GameView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 03/02/2025.
//

import SwiftUI
import SpriteKit

/// Container view for the spritekit scene
struct GameView: View {
    @State private var gameScene: GameScene = {
        return GameScene.create(isEmpty: false)
    }()
    
    var body: some View {
        SpriteView(scene: gameScene)
            .background(
                Color.black
                    .ignoresSafeArea()
            )
    }
}

#Preview {
    GameView()
}
