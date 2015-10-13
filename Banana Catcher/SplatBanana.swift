import UIKit
import SpriteKit

class SplatBanana: SKSpriteNode {

    init() {
        let direction = CGFloat([-1.0, 1.0][Int(arc4random_uniform(2))])
        let texture = SKTexture(imageNamed: "banana_splat_\(1)")

        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.xScale *= direction
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Ignorable
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        animate()
        decay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate() {
        let textures = (1...5).map { SKTexture(imageNamed: "banana_splat_\($0).png") }
        self.runAction(SKAction.animateWithTextures(textures, timePerFrame: 0.05))
    }
    
    private func decay() {
        let wait = SKAction.waitForDuration(1.0)
        let fadeAway = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        let remove = SKAction.runBlock() { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([wait, fadeAway, remove]))
    }
}
