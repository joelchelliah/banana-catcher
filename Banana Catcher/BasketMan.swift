import UIKit
import SpriteKit

class BasketMan: SKSpriteNode {

    private let velocity: CGFloat = 6.0
    private var catch_textures = [SKTexture]()
    
    init() {
        let texture = SKTexture(imageNamed: "idle_1.png")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.BasketMan
        self.physicsBody?.contactTestBitMask = CollisionCategories.Banana
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        loadTextures()
        animate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(touch: CGPoint) {
        let dx = touch.x - position.x
        let mag = abs(dx)
        
        if(mag > 3.0) {
            position.x += dx / mag * velocity
        }
    }
    
    func collect() {
        let catchAnim = SKAction.animateWithTextures(catch_textures, timePerFrame: 0.05)
        let backToIdle = SKAction.runBlock { self.texture = SKTexture(imageNamed: "idle_1.png") }
        
        self.runAction(SKAction.sequence([catchAnim, backToIdle]))
    }
    
    private func loadTextures() {
        for i in 1...7 {
            catch_textures.append(SKTexture(imageNamed: "catch_\(i).png"))
        }
    }
    
    private func animate() {
    }
}
