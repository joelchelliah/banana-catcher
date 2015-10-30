import UIKit
import SpriteKit

class EvilMonkey: SKSpriteNode {
    
    private var step: CGFloat = 1.0
    private var direction: CGFloat = -1.0
    private var cooldown: Double = 2.0
    private var canThrow: Bool = false
    private var victorious: Bool = false
    
    private var flyingTextures = [SKTexture]()

    init() {
        let texture = SKTexture(imageNamed: "flying_1.png")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = false

        self.physicsBody?.categoryBitMask = CollisionCategories.EvilMonkey
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        
        loadTextures()
        animate()
        activateCooldown()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(range: CGFloat) {
        updateStep()
        updatePosition(range)
    }
    
    func enrage() {
        if cooldown > 0.5 {
            cooldown -= 0.1
        } else {
            cooldown = 1.0
        }
    }
    
    func win() {
        victorious = true
    }
    
    func canThrowBanana() -> Bool {
        if victorious { return false }
        
        let couldThrow = canThrow
        if canThrow {
            canThrow = false
            activateCooldown()
        }
        return couldThrow
    }
    
    private func updateStep() {
        if step < 1.0 {
            if Int(arc4random_uniform(6)) == 1 {
                step = CGFloat(arc4random_uniform(4))
            }
        } else { step -= 0.05 }
    }
    
    private func updatePosition(range: CGFloat) {
        let halfWidth = size.width / 2
        let safetyDistance: CGFloat = 0.5
        
        if (position.x > range - halfWidth) {
            position.x = range - halfWidth - safetyDistance
            direction = -direction
        }
        
        if (position.x < halfWidth) {
            position.x = halfWidth + safetyDistance
            direction = -direction
        }
        position.x += direction * step
    }
    
    
    private func loadTextures() {
        flyingTextures = (1...8).map { SKTexture(imageNamed: "flying_\($0).png") }
    }
    
    private func animate() {
        let anim = SKAction.animateWithTextures(flyingTextures, timePerFrame: 0.06)
        
        self.runAction(SKAction.repeatActionForever(anim))
    }
    
    private func activateCooldown() {
        NSTimer.scheduledTimerWithTimeInterval(cooldown, target: self, selector: "updateCanThrow", userInfo: nil, repeats: false)
    }
    
    private func updateCanThrow() {
        canThrow = true
    }
}
