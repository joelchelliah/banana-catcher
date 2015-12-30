import UIKit
import SpriteKit

class BasketMan: SKSpriteNode {

    private let velocity: CGFloat = 8.0
    
    private var invincible: Bool = false
    
    private var idleTexture = SKTexture(imageNamed: "idle.png")
    private var blinkTextures = [SKTexture]()
    private var catchTextures = [SKTexture]()
    private var oneUpTextures = [SKTexture]()
    private var ouchTextures = [SKTexture]()
    private var sadTextures = [SKTexture]()
    
    init() {
        super.init(texture: idleTexture, color: SKColor.clearColor(), size: idleTexture.size())
        
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
        
        if(mag > 5.0) {
            position.x += dx / mag * velocity
        }
    }
    
    func isInvincible() -> Bool {
        return invincible
    }
    
    func collect() {
        let animation = SKAction.animateWithTextures(catchTextures, timePerFrame: 0.05)
        
        playSound(Sounds.caught)
        runAction(animation)
    }
    
    func lifeUp() {
        let animation = SKAction.animateWithTextures(oneUpTextures, timePerFrame: 0.05)
        
        playSound(Sounds.powerup)
        runAction(animation)
    }
    
    func ouch() {
        invincible = true
        
        let animation = SKAction.animateWithTextures(ouchTextures, timePerFrame: 0.05)
        let fadeOut = SKAction.fadeAlphaTo(0.3, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let fadeOutIn = SKAction.repeatAction(SKAction.sequence([fadeOut, fadeIn]), count: 3)
        let ouchAnimation = SKAction.group([animation, fadeOutIn])
        
        let wait = SKAction.waitForDuration(1.0)
        let removeInvincibility = SKAction.runBlock { self.invincible = false }
        
        playSound(Sounds.ouch)
        runAction(SKAction.sequence([ouchAnimation, wait, removeInvincibility]))
    }
    
    func frown() {
        let animation = SKAction.animateWithTextures(sadTextures, timePerFrame: 0.07)
        
        self.runAction(animation)
    }
    
    private func animate() {
        let frames = [blinkTextures, [idleTexture]].flatMap { $0 }
        
        let blink = SKAction.animateWithTextures(frames, timePerFrame: 0.05)
        let delay = SKAction.waitForDuration(1.0)
        let animation = SKAction.sequence([blink, delay, blink, blink, delay, delay])
        
        self.runAction(SKAction.repeatActionForever(animation))
    }
    
    private func loadTextures() {
        blinkTextures = (1...3).map { SKTexture(imageNamed: "blink_\($0).png") }
        catchTextures = (1...10).map { SKTexture(imageNamed: "catch_\($0).png") }
        oneUpTextures = (1...11).map { SKTexture(imageNamed: "1up_\($0).png") }
        ouchTextures  = (1...10).map { SKTexture(imageNamed: "ouch_\($0).png") }
        sadTextures  = (1...8).map { SKTexture(imageNamed: "sad_\($0).png") }
    }
}
