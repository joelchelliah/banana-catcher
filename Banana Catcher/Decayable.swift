import UIKit
import SpriteKit

class Decayable: SKSpriteNode {
    
    init(texture: SKTexture, pos: CGPoint) {
        let direction = CGFloat([-1.0, 1.0][Int(arc4random_uniform(2))])
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.position = pos
        self.xScale *= direction
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Ignorable
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        splat()
        decay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func splat() {
        fatalError("splat has not been overridden!")
    }
    
    private func decay() {
        let fadeAway = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        let remove = SKAction.runBlock() { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([fadeAway, remove]))
    }
}
