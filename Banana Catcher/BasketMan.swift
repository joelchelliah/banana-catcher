import UIKit
import SpriteKit

class BasketMan: SKSpriteNode {

    private let velocity: CGFloat = 6.0
    private var blink_textures = [SKTexture]()
    private var catch_textures = [SKTexture]()
    
    init() {
        let texture = SKTexture(imageNamed: "idle.png")
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
        let sound = SKAction.playSoundFileNamed("catch.wav", waitForCompletion: false)
        let animation = SKAction.animateWithTextures(catch_textures, timePerFrame: 0.05)
        
        self.runAction(SKAction.sequence([sound, animation]))
    }
    
    private func animate() {
        let blinkAnim = SKAction.animateWithTextures(blink_textures, timePerFrame: 0.05)
        let delay = SKAction.waitForDuration(1.0)
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([blinkAnim, delay])))
    }
    
    private func loadTextures() {
        for i in 1...4 {
            blink_textures.append(SKTexture(imageNamed: "blink_\(i).png"))
        }
        for i in 1...8 {
            catch_textures.append(SKTexture(imageNamed: "catch_\(i).png"))
        }
    }
}
