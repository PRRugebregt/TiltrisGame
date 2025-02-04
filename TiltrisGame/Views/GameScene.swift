import SpriteKit
import CoreMotion

class GameScene: SKScene {
    private let motionManager: CMMotionManager = CMMotionManager()

    private var gameBounds: SKShapeNode?
    private var tetrisBlocks: [SKNode] = []
    private var currentBlock: SKNode?
        
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.2)
        physicsWorld.contactDelegate = self
        
        startTrackingDeviceTilt()
        setupGameBounds(view: view)
        spawnBlock(at: CGPoint(x: size.width / 2, y: size.height * 0.8))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentBlock?.zRotation += CGFloat.pi / 2
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
        let gravityX: CGFloat = CGFloat(roll) * 0.2
        let gravityY: CGFloat = CGFloat(pitch) * 0.2
        
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
        let block = TetrisBlockNode(tetrisShape: randomShape)
        block.position = position
        tetrisBlocks.append(block) // Add to array
        currentBlock = block
        addChild(block)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
                
        // Check if player has collided with game bounds
        if contact.isBlockOrBoundsCollision(currentBlockPosition: currentBlock?.position) {
            // Only check collisions with the current block
            guard currentBlock?.physicsBody == bodyA || currentBlock?.physicsBody == bodyB else {
                return
            }
            
            currentBlock?.physicsBody?.mass = 1000
            currentBlock?.physicsBody?.friction = 1
            
            // Spawn new block
            if let gameBounds = gameBounds {
                let gameBoundsFrame = gameBounds.frame
                let randomX = CGFloat.random(in: gameBoundsFrame.minX + 20...gameBoundsFrame.maxX - 20)
                let randomY = size.height * 0.8
                let position = CGPoint(x: randomX, y: randomY)
                spawnBlock(at: position)
            }
        }
    }
}
