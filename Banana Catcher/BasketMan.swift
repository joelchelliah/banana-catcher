import UIKit
import SpriteKit

class BasketMan: SKSpriteNode {

    private let velocity: CGFloat = 6.0
    
    private var blinkTextures = [SKTexture]()
    private var catchTextures = [SKTexture]()
    private var ouchTextures = [SKTexture]()
    
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
        let animation = SKAction.animateWithTextures(catchTextures, timePerFrame: 0.05)
        
        self.runAction(SKAction.sequence([sound, animation]))
    }
    
    func ouch() {
        let sound = SKAction.playSoundFileNamed("splat.wav", waitForCompletion: false)
        let animation = SKAction.animateWithTextures(ouchTextures, timePerFrame: 0.05)
        
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let fadeIn = SKAction.fadeInWithDuration(0.1)
        let fadeOutIn = SKAction.repeatAction(SKAction.sequence([fadeOut, fadeIn]), count: 3)
        
        self.runAction(SKAction.sequence([sound, animation, fadeOutIn]))
    }
    
    private func animate() {
        let blinkAnim = SKAction.animateWithTextures(blinkTextures, timePerFrame: 0.05)
        let delay = SKAction.waitForDuration(1.0)
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([blinkAnim, delay])))
    }
    
    private func loadTextures() {
        blinkTextures = (1...4).map { SKTexture(imageNamed: "blink_\($0).png") }
        catchTextures = (1...8).map { SKTexture(imageNamed: "catch_\($0).png") }
        ouchTextures  = (1...9).map { SKTexture(imageNamed: "ouch_\($0).png") }
    }
}
