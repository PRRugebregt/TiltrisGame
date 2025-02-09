//
//  ScoreManager.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 05/02/2025.
//

import Foundation
import SpriteKit

protocol ScoreManagerProtocol {
    var scoreBins: [ScoreBin] { get set }
    var delegate: ScoreBinProtocol? { get set }
    func checkForScore(_ scoreBin: ScoreBin, currentBlock: TetrisBlockNode) -> Bool
}

/// Angle enum with rawValue that represents radians for rotation
enum Angle: CGFloat, CaseIterable {
    case zero = 0
    case ninety = 1.57079632679
    case oneEighty = 3.14159265359
    case twoSeventy = 4.71238898038
    
    func nextAngle() -> Angle {
        switch self {
        case .zero:
            return .ninety
        case .ninety:
            return .oneEighty
        case .oneEighty:
            return .twoSeventy
        case .twoSeventy:
            return .zero
        }
    }
    
    static func isBothHorizontalOrVertical(angleA: Angle, angleB: Angle) -> Bool {
        return (angleA.isVertical() && angleB.isVertical()) || (angleA.isHorizontal() && angleB.isHorizontal())
    }
    
    func isHorizontal() -> Bool {
        return self == .ninety || self == .twoSeventy
    }
    
    func isVertical() -> Bool {
        return self == .zero || self == .oneEighty
    }
}

class ScoreManager: ScoreManagerProtocol {
    var scoreBins: [ScoreBin] = []
    var score: Int = 0
    private var switchTimer: Timer?
    private var speedUpTimer: Timer?

    weak var delegate: ScoreBinProtocol? {
        didSet {
            // Make sure delegate is set when setting up the bins
            randomizeBins()
        }
    }
    
    init() {
        setupTimer()
    }
    
    private func setupTimer() {
        switchTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { timer in
            self.randomizeBins()
        })
        // Tells delegate to increase gravity force
        speedUpTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { timer in
            self.delegate?.didSpeedUp()
        })
    }
    
    private func randomizeBins() {
        scoreBins = []
        // Make 8 bins
        for _ in 1...8 {
            guard let randomShape = TetrisShape.allCases.randomElement(),
                    let randomAngle = Angle.allCases.randomElement() else {
                return
            }
            // Add a new score bin with a random shape and rotation 
            scoreBins.append(
                ScoreBin(
                    shape: randomShape,
                    angle: randomAngle
                )
            )
        }
        
        delegate?.didResetScoreBins(scoreBins: scoreBins)
    }
    
    func checkForScore(_ scoreBin: ScoreBin, currentBlock: TetrisBlockNode) -> Bool {
        // Check if the current falling block has the same shape and rotation, which awards points
        switch currentBlock.shape {
        case .square:
            // Square has no rotation
            guard scoreBin.shape == currentBlock.shape else {
                return false
            }
        case .tShape, .lShape:
            // Check precise rotation and shape
            guard scoreBin.shape == currentBlock.shape, 
                    scoreBin.angle == currentBlock.angle else {
                return false
            }
        case .long:
            // Only check whether its vertical or horizontal
            guard scoreBin.shape == currentBlock.shape, 
                    Angle.isBothHorizontalOrVertical(angleA: currentBlock.angle, angleB: scoreBin.angle) else {
                return false
            }
        }
        
        addScore(for: currentBlock.shape)
        return true
    }
    
    private func addScore(for shape: TetrisShape) {
        score += shape.calculateScore()
        // Update score
        delegate?.updateScoreLabel(text: "SCORE: \(score)")
    }
}
