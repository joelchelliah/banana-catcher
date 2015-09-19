import UIKit
import SpriteKit

class Ground: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "ground")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())

        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Ground
        self.physicsBody?.contactTestBitMask = CollisionCategories.Banana
        self.physicsBody?.collisionBitMask = CollisionCategories.BasketMan | CollisionCategories.Banana
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
