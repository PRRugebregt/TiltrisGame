//
//  GameView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 03/02/2025.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    private var gameScene: GameScene = {
        let gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        return gameScene
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
