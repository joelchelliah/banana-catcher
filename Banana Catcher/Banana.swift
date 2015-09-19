import UIKit
import SpriteKit

class Banana: SKSpriteNode {
    
    private var splat: Bool = false

    init() {
        let texture = SKTexture(imageNamed: "banana")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Banana
        self.physicsBody?.contactTestBitMask = CollisionCategories.BasketMan | CollisionCategories.Ground
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody

        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isSplat() -> Bool {
        return splat
    }
    
    func goSplat() {
        splat = true
        
        decay()
    }
    
    private func animate() {
        let rotDir = [-1.0, 1.0][Int(arc4random_uniform(2))]
        let rotSpeed = 2.0 / Double(arc4random_uniform(5) + 1)
        let rot = SKAction.rotateByAngle(CGFloat(rotDir * M_PI) * 2.0, duration: rotSpeed)
        
        self.runAction(SKAction.repeatActionForever(rot))
    }
    
    private func decay() {
        self.physicsBody?.allowsRotation = false
        
        let fadeAway = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        let remove = SKAction.runBlock() { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([fadeAway, remove]))
    }
}
