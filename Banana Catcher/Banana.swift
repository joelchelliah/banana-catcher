import UIKit
import SpriteKit

class Banana: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "banana")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.collisionBitMask = 0

        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate() {
        let rotDir = [-1.0, 1.0][Int(arc4random_uniform(2))]
        let rotSpeed = 2.0 / Double(arc4random_uniform(5) + 1)
        let rot = SKAction.rotateByAngle(CGFloat(rotDir * M_PI) * 2.0, duration: rotSpeed)
        
        self.runAction(SKAction.repeatActionForever(rot))
    }
}
