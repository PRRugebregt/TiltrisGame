//
//  HomeViewModel.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import Foundation
import UIKit

class HomeViewModel: ObservableObject {
    var fallingTetrisShape: TetrisShape {
        TetrisShape.allCases.randomElement() ?? .tShape
    }
    // Returns a random position for falling shape
    var screenWidth: CGFloat {
        CGFloat.random(in: UIScreen.main.bounds.width / 2 ... UIScreen.main.bounds.width - 100)
    }
    // Returns a random angle for falling shape
    var angle: Angle {
        Angle.allCases.randomElement() ?? .zero
    }

    func randomX() -> CGFloat {
        CGFloat.random(in: 100 ... 800)
    }
}
