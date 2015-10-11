import UIKit
import SpriteKit

class SplatBanana: SKSpriteNode {

    init() {
        let splatDir = Int(arc4random_uniform(2)) + 1
        let texture = SKTexture(imageNamed: "banana_splat_\(splatDir)")

        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Ignorable
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        decay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func decay() {
        let fadeAway = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        let remove = SKAction.runBlock() { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([fadeAway, remove]))
    }
}
