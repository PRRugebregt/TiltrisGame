//
//  ScoreManager.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 05/02/2025.
//

import Foundation
import SpriteKit

protocol ScoreManagerProtocol {
    var label: SKLabelNode { get set }
    var scoreBins: [ScoreBin] { get set }
    var delegate: ScoreBinProtocol? { get set }
    func checkForScore(_ scoreBinNode: TheBin, currentBlock: TetrisBlockNode) -> Bool
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
}

class ScoreManager: ScoreManagerProtocol {
    var scoreBins: [ScoreBin] = []
    var score: Int = 0
    var label: SKLabelNode = SKLabelNode(text: "Score: ")
    private var switchTimer: Timer?
    private var speedUpTimer: Timer?

    weak var delegate: ScoreBinProtocol? {
        didSet {
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
        speedUpTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: { timer in
            self.delegate?.didSpeedUp()
        })
    }
    
    private func randomizeBins() {
        scoreBins = []
        var newScoreBins: [ScoreBin] = []
        
        for _ in 1...3 {
            guard let randomShape = TetrisShape.allCases.randomElement(), let randomAngle = Angle.allCases.randomElement() else {
                return
            }
            // Add a new score bin with a random shape and rotation 
            newScoreBins.append(
                ScoreBin(
                    shape: randomShape,
                    rotation: randomAngle.rawValue
                )
            )
        }
        scoreBins = newScoreBins
        
        delegate?.didResetScoreBins(scoreBins: scoreBins)
    }
    
    func checkForScore(_ scoreBinNode: TheBin, currentBlock: TetrisBlockNode) -> Bool {
        // Check if the current falling block has the same shape and rotation, which awards points
        switch currentBlock.shape {
        case .square:
            guard scoreBinNode.scoreBin.shape == currentBlock.shape else {
                return false
            }
        case .tShape, .lShape:
            guard scoreBinNode.scoreBin.shape == currentBlock.shape, Angle(rawValue: scoreBinNode.scoreBin.rotation) == currentBlock.angle else {
                return false
            }
        case .long:
            guard scoreBinNode.scoreBin.shape == currentBlock.shape else {
                return false
            }
            guard ((currentBlock.angle == .zero || currentBlock.angle == .oneEighty) && (Angle(rawValue: scoreBinNode.scoreBin.rotation) == .zero || Angle(rawValue: scoreBinNode.scoreBin.rotation) == .oneEighty)) || ((currentBlock.angle == .ninety || currentBlock.angle == .twoSeventy) && (Angle(rawValue: scoreBinNode.scoreBin.rotation) == .ninety || Angle(rawValue: scoreBinNode.scoreBin.rotation) == .twoSeventy)) else {
                return false
            }
        }
        
        addScore(for: currentBlock.shape)
        return true
    }
    
    private func addScore(for shape: TetrisShape) {
        score += shape.calculateScore()
        label.text = "SCORE: \(score)"
    }
}
