import UIKit
import SpriteKit

class BasketMan: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "box")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.BasketMan
        self.physicsBody?.contactTestBitMask = CollisionCategories.Banana
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        animate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collect() {
        let shrink1 = SKAction.scaleYTo(0.8, duration: 0.1)
        let grow1 = SKAction.scaleYTo(1.25, duration: 0.1)
        let shrink2 = SKAction.scaleYTo(0.9, duration: 0.05)
        let grow2 = SKAction.scaleYTo(1.111111, duration: 0.05)
        
        self.runAction(SKAction.sequence([shrink1, grow1, shrink2, grow2]))
    }
    
    private func animate() {
    }
}
