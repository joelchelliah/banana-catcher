import UIKit
import SpriteKit

class EvilMonkey: SKSpriteNode {
    
    var direction: CGFloat = -1.0
    let step: CGFloat = 1.0

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
    
    private func animate() {
    }
}
