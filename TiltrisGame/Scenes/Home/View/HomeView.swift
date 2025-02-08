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
    @State var isFalling = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(.black)
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
                    x: CGFloat.random(in: 100 ... 800),
                    y: isFalling ? 1200 : -800
                )
            )
            .onAppear {
                animate()
            }
            VStack {
                TetrisShapeView(screenWidth: UIScreen.main.bounds.width, blockWidth: 60)
                    .frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
                    .ignoresSafeArea()
                    .padding()
                HomeTitleView()
                    .zIndex(20)
                    .padding()
                Spacer()
                Button(action: {
                    coordinator.navigate(to: .instruction)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.yellow)
                        Text("Start Game")
                            .foregroundStyle(.black)
                            .font(.title)
                    }
                    .frame(height: 80)
                    .padding()
                })
                Spacer()
            }
        }
    }
    private func animate() {
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
