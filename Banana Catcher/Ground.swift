import UIKit
import SpriteKit

class Ground: SKSpriteNode {

    init() {
        let groundSize = CGSizeMake(400, 145)
        super.init(texture: nil, color: SKColor.clearColor(), size: groundSize)

        self.physicsBody = SKPhysicsBody(rectangleOfSize: groundSize)
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
