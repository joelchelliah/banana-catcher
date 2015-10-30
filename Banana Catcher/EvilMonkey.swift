import UIKit
import SpriteKit

class EvilMonkey: SKSpriteNode {
    
    private let step: CGFloat = 1.0
    private var direction: CGFloat = -1.0
    private var cooldown: Double = 2.0
    private var canThrow: Bool = true
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(range: CGFloat) {
        let halfWidth = size.width / 2
        
        if (position.x > range - halfWidth) || (position.x < halfWidth) {
                direction = -direction
        }
        position.x += direction * step
    }
    
    func enrage() {
        if cooldown > 0.5 {
            cooldown -= 0.2
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
            NSTimer.scheduledTimerWithTimeInterval(cooldown, target: self, selector: "updateCanThrow", userInfo: nil, repeats: false)
        }
        return couldThrow
    }
    
    internal func updateCanThrow() {
        canThrow = true
    }
    
    private func loadTextures() {
        flyingTextures = (1...8).map { SKTexture(imageNamed: "flying_\($0).png") }
    }
    
    private func animate() {
        let anim = SKAction.animateWithTextures(flyingTextures, timePerFrame: 0.06)
        
        self.runAction(SKAction.repeatActionForever(anim))
    }
}
