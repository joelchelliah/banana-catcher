import UIKit
import SpriteKit

class EvilMonkey: SKSpriteNode {
    
    private let step: CGFloat = 1.0
    private var direction: CGFloat = -1.0
    private var cooldown: Double = 2.0
    private var canThrow: Bool = true

    init() {
        let texture = SKTexture(imageNamed: "evil-monkey")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = false

        self.physicsBody?.categoryBitMask = CollisionCategories.EvilMonkey
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(range: CGFloat) {
        if (position.x > range - size.width) || (position.x < size.width) {
                direction = -direction
        }
        position.x += direction * step
    }
    
    func enrage() {
        if cooldown > 0.5 {
            cooldown -= 0.1
        } else {
            cooldown = 1.0
        }
    }
    
    func canThrowBanana() -> Bool {
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
    
    private func animate() {
    }
}
