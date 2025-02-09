//
//  HomeTitleView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import Foundation
import SwiftUI

/// Titleview made out of tetris shapes
struct HomeTitleView: View {
    private let screenWidth = UIScreen.main.bounds.width / 9
    private let blockWidth: CGFloat = 10
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                // T
                TetrisShapeView(
                    screenWidth: screenWidth,
                    blockWidth: blockWidth,
                    shape: .tShape,
                    angle: .oneEighty
                )
                // I
                TetrisShapeView(
                    screenWidth: screenWidth,
                    blockWidth: blockWidth,
                    shape: .long,
                    angle: .zero
                )
                // L
                TetrisShapeView(
                    screenWidth: screenWidth,
                    blockWidth: blockWidth,
                    shape: .lShape,
                    angle: .twoSeventy
                )
                // T
                TetrisShapeView(
                    screenWidth: screenWidth,
                    blockWidth: blockWidth,
                    shape: .tShape,
                    angle: .oneEighty
                )
                // R
                Text("R")
                    .font(Font.system(size: 30))
                    .foregroundStyle(.white)
                // I
                TetrisShapeView(
                    screenWidth: screenWidth,
                    blockWidth: blockWidth,
                    shape: .long,
                    angle: .zero
                )
                // S
                Text("S")
                    .font(Font.system(size: 30))
                    .foregroundStyle(.white)
            }
            .padding()

            Rectangle()
                .opacity(0.4)
                .foregroundStyle(.yellow)
                .ignoresSafeArea()
        }
        .frame(height: 40)
    }
}
