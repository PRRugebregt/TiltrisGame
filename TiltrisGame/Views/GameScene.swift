import SpriteKit
import CoreMotion

protocol ScoreBinProtocol: AnyObject {
    func didResetScoreBins(scoreBins: [ScoreBin])
    func didSpeedUp()
}

class GameScene: SKScene {
    private let motionManager: CMMotionManager = CMMotionManager()
    private var scoreManager: ScoreManagerProtocol = ScoreManager()
    
    private var gameBounds: SKShapeNode?
    private var tetrisBlocks: [SKNode] = []
    private var currentBlock: TetrisBlockNode?
    private var scoreBinNodes: [ScoreBinNode] = []
    
    private var isAnimating = false
    
    private var gravityPull = 0.2
        
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -gravityPull)
        physicsWorld.contactDelegate = self
        
        scoreManager.delegate = self
        
        startTrackingDeviceTilt()
        setupGameBounds(view: view)
        spawnBlock(at: CGPoint(x: size.width / 2, y: size.height * 0.8))
        addChild(scoreManager.label)
        scoreManager.label.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 80)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let currentAngle = currentBlock?.angle else { return }
        currentBlock?.angle = currentAngle.nextAngle()
    }
    
    private func startTrackingDeviceTilt() {
        guard motionManager.isAccelerometerAvailable else {
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data, error == nil else {
                if let error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let roll = data.acceleration.x
            let pitch = data.acceleration.y
            
            // Shift gravity
            self.updateGravity(roll: roll, pitch: pitch)
        }
    }
    
    private func updateGravity(roll: Double, pitch: Double) {
        let gravityX: CGFloat = CGFloat(roll) * gravityPull
        let gravityY: CGFloat = CGFloat(pitch) * gravityPull
        
        // When rotating the device we want to let the blocks always fall to the bottom of your screen
        let gravityVector = CGVector(dx: gravityX, dy: gravityY)
        
        physicsWorld.gravity = gravityVector
    }
    
    private func setupGameBounds(view: SKView) {
        let lineWidth: CGFloat = 10
        let safeInsets = view.safeAreaInsets
        
        let gameFrame = CGRect(
            x: safeInsets.left + lineWidth,
            y: safeInsets.bottom + lineWidth,
            width: size.width - safeInsets.left - safeInsets.right - 2 * lineWidth,
            height: size.height - safeInsets.top - safeInsets.bottom - 2 * lineWidth
        )
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: gameFrame)
        physicsBody?.categoryBitMask = PhysicsCategory.bounds.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.block.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.block.rawValue
        
        gameBounds = SKShapeNode(rect: gameFrame)
        gameBounds?.strokeColor = .white
        gameBounds?.lineWidth = lineWidth
        
        addChild(gameBounds!)
    }
    
    private func spawnBlock(at position: CGPoint) {
        guard let randomShape = TetrisShape.allCases.randomElement() else { return }
        let block = TetrisBlockNode(tetrisShape: randomShape, hasPhysicsBody: true)
        block.position = position
        currentBlock = block
        addChild(block)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isAnimating else { return }
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        guard let currentBlock else { return }

        let isCorrectShape: Bool
        
        if bodyA.categoryBitMask == PhysicsCategory.scoreBin.rawValue {
            guard let scoreBinNode = bodyA.node as? TheBin else { return }
            isCorrectShape = scoreManager.checkForScore(scoreBinNode, currentBlock: currentBlock)
        } else if bodyB.categoryBitMask == PhysicsCategory.scoreBin.rawValue {
            guard let scoreBinNode = bodyB.node as? TheBin else { return }
            isCorrectShape = scoreManager.checkForScore(scoreBinNode, currentBlock: currentBlock)
        } else {
            return
        }
        
        isAnimating = true
        
        let action = SKAction.customAction(withDuration: 2) { node, float in
            if let node = node as? TetrisBlockNode {
                for child in node.children {
                    if let child = child as? SKSpriteNode {
                        child.run(SKAction.colorize(with: isCorrectShape ? .green : .red, colorBlendFactor: 1, duration: 2))
                    }
                }
            }
        }
        
        currentBlock.run(action) {
            currentBlock.removeFromParent()
            let position = CGPoint(x: CGFloat.random(in: 100 ... UIScreen.main.bounds.width - 100), y: UIScreen.main.bounds.height - 200)
            self.spawnBlock(at: position)
            self.isAnimating = false
        }
    }
}

extension GameScene: ScoreBinProtocol {
    func didResetScoreBins(scoreBins: [ScoreBin]) {
        scoreBinNodes.forEach { $0.removeFromParent() }
        scoreBinNodes = []
        
        let center = UIScreen.main.bounds.width / 2 - 50
        
        for (index, scoreBin) in scoreBins.enumerated() {
            let scoreBinNode = ScoreBinNode(scoreBin: scoreBin)
            var positionX: CGFloat {
                switch index {
                case 0:
                    return center
                case 1:
                    return center - 110
                case 2:
                    return center + 110
                default:
                    return 0
                }
            }
            scoreBinNode.position = CGPoint(x: positionX, y: 30)
            addChild(scoreBinNode)
            scoreBinNodes.append(scoreBinNode)
        }
    }
    
    func didSpeedUp() {
        gravityPull += 0.2
    }
}
