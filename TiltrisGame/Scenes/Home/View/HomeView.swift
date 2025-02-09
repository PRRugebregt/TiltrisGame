//
//  HomeView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI
import SpriteKit

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var homeViewModel = HomeViewModel()
    @State private var shouldAnimate = true
    @State private var isFalling = false
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .foregroundStyle(.black)
                .ignoresSafeArea()
            // Falling tetrisShape
            TetrisShapeView(
                screenWidth: 150,
                blockWidth: 20,
                shape: homeViewModel.fallingTetrisShape,
                angle: homeViewModel.angle
            )
            .position(
                CGPoint(
                    x: homeViewModel.randomX(),
                    y: isFalling ? 800 : -800
                )
            )
            .onAppear {
                animate()
            }
            VStack {
                // Logo
                TetrisShapeView(screenWidth: UIScreen.main.bounds.width, blockWidth: 60)
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: 200, 
                        alignment: .center
                    )
                    .ignoresSafeArea()
                    .padding()
                // Title
                HomeTitleView()
                    .padding()
                Spacer()
                HomeButtonView(text: "Start game", color: .yellow) {
                    coordinator.navigate(to: .instruction)
                }
                HomeButtonView(text: "Settings", color: .orange) {
                    coordinator.sheet(destination: .settings)
                }
                Spacer()
            }
        }
        // Somehow the animating falling Spriteview caused a out of memory crash whenever navigating away from this view. Making sure the animation stops when navigating away from this view.
        .onAppear {
            shouldAnimate = true
        }
        .onDisappear {
            shouldAnimate = false
        }
    }
    
    private func animate() {
        print("### shouldAnimate \(shouldAnimate)")
        guard shouldAnimate else { return }
        withAnimation(.linear(duration: 5)) {
            isFalling = true
        } completion: {
            self.isFalling = false
            animate()
        }
    }
}

#Preview {
    HomeView()
}
