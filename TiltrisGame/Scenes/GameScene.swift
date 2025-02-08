import SpriteKit
import CoreMotion

protocol ScoreBinProtocol: AnyObject {
    func didResetScoreBins(scoreBins: [ScoreBin])
    func didSpeedUp()
    func updateScoreLabel(text: String)
}

class GameScene: SKScene {
    private let motionManager: CMMotionManager = CMMotionManager()
    private var scoreManager: ScoreManagerProtocol = ScoreManager()
    
    private let isEmpty: Bool // Indicates whether there are scoreBins or not
    
    private var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: 0")
    private var gameBounds: SKShapeNode?
    private var tetrisBlocks: [SKNode] = []
    private var currentBlock: TetrisBlockNode?
    private var scoreBinNodes: [ScoreBinNode] = []
    
    private var isAnimating = false // Flag to check if the block is in the middle of animating 
    
    private var gravityPull = 0.2
        
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -gravityPull)
        physicsWorld.contactDelegate = self
        
        startTrackingDeviceTilt()
        setupGameBounds(view: view)
        spawnBlock()
        if !isEmpty {
            scoreManager.delegate = self
            setupScoreLabel()
        }
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
    
    // MARK: Setup labels
    
    private func setupGameBounds(view: SKView) {
        let gameBounds = NodeConfigurator.createGameBounds(size: self.size, view: view)
        self.gameBounds = gameBounds
        addChild(gameBounds)
    }
    
    private func setupScoreLabel() {
        guard let view else { return }
        addChild(scoreLabel)
        scoreLabel.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height - 80)
        scoreLabel.fontColor = .yellow
        scoreLabel.zPosition = 20
    }
    
    private func spawnBlock() {
        currentBlock?.removeFromParent()

        guard let randomShape = TetrisShape.allCases.randomElement() else { return }
        
        let position = CGPoint(
            x: CGFloat.random(in: 100 ... UIScreen.main.bounds.width - 100),
            y: UIScreen.main.bounds.height - 200
        )
        let block = TetrisBlockNode(
            tetrisShape: randomShape,
            hasPhysicsBody: true
        )
        block.position = position
        currentBlock = block
        addChild(block)
    }
    
    static func create(isEmpty: Bool) -> GameScene {
        let gameScene = GameScene(isEmpty: isEmpty)
        gameScene.scaleMode = .resizeFill
        return gameScene
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isAnimating else { return }
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        guard let currentBlock else { return }

        let isCorrect: Bool
        
        if bodyA.categoryBitMask == PhysicsCategory.scoreBin.rawValue {
            guard let scoreBinNode = bodyA.node as? BinNode else { return }
            isCorrect = scoreManager.checkForScore(scoreBinNode.scoreBin, currentBlock: currentBlock)
            if !isCorrect {
                print("### WRONG")
                print("### scorebin Shape \(scoreBinNode.scoreBin.shape) Angle \(scoreBinNode.scoreBin.angle)")
                print("### currentBlock Shape \(currentBlock.shape) Angle \(currentBlock.angle)")
            }
        } else if bodyB.categoryBitMask == PhysicsCategory.scoreBin.rawValue {
            guard let scoreBinNode = bodyB.node as? BinNode else { return }
            isCorrect = scoreManager.checkForScore(scoreBinNode.scoreBin, currentBlock: currentBlock)
            if !isCorrect {
                print("### WRONG")
                print("### scorebin Shape \(scoreBinNode.scoreBin.shape) Angle \(scoreBinNode.scoreBin.angle)")
                print("### currentBlock Shape \(currentBlock.shape) Angle \(currentBlock.angle)")
            }
        } else {
            return
        }
        
        isAnimating = true
        
        let action = currentBlock.finalActionAnimation(isCorrect)
        
        currentBlock.run(action) {
            self.spawnBlock()
            self.isAnimating = false
        }
    }
}

extension GameScene: ScoreBinProtocol {
    func didResetScoreBins(scoreBins: [ScoreBin]) {
        guard !isEmpty else { return }
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
    
    func updateScoreLabel(text: String) {
        scoreLabel.text = text
    }
}
