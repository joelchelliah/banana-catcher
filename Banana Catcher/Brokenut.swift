import UIKit
import SpriteKit

class Brokenut: SKSpriteNode {
    
    init(pos: CGPoint) {
        let direction = CGFloat([-1.0, 1.0][Int(arc4random_uniform(2))])
        let texture = SKTexture(imageNamed: "brokenut_1")
        
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
    
    
    private func splat() {
        let textures = (1...10).map { SKTexture(imageNamed: "brokenut_\($0).png") }
        
        let sound = SKAction.playSoundFileNamed("splat.wav", waitForCompletion: false)
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        runAction(SKAction.sequence([sound, animation]))
    }
    
    private func decay() {
        let fadeAway = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        let remove = SKAction.runBlock() { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([fadeAway, remove]))
    }
}
