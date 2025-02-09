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
    @EnvironmentObject var coordinator: Coordinator
    @State private var gameScene: GameScene?
    
    var body: some View {
        VStack {
            if let gameScene {
                SpriteView(scene: gameScene)
                    .background(
                        Color.black
                            .ignoresSafeArea()
                    )
            }
        }
        .onAppear {
            self.gameScene = GameScene.create(
                isEmpty: false,
                difficulty: coordinator.appState.difficulty
            )
        }
    }
}

#Preview {
    GameView()
}
