import UIKit
import SpriteKit

class BasketMan: SKSpriteNode {

    private let velocity: CGFloat = 8.0
    
    private var invincible: Bool = false
    private var sizeChanged: Bool = false
    private let originalWidth: CGFloat
    
    private var idleTexture = SKTexture(imageNamed: "idle.png")
    private var blinkTextures = [SKTexture]()
    private var catchTextures = [SKTexture]()
    private var oneUpTextures = [SKTexture]()
    private var greenTextures = [SKTexture]()
    private var purpleTextures = [SKTexture]()
    private var ouchTextures = [SKTexture]()
    private var sadTextures = [SKTexture]()
    
    init() {
        originalWidth = idleTexture.size().width
        super.init(texture: idleTexture, color: SKColor.clearColor(), size: idleTexture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = CollisionCategories.BasketMan
        self.physicsBody?.contactTestBitMask = CollisionCategories.Banana
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        loadTextures()
        idle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move(touch: CGPoint, range: CGFloat) {
        let leftEdge = size.width / 2
        let rightEdge = range - size.width / 2
        
        if position.x < leftEdge {
            position.x = leftEdge
        } else if position.x > rightEdge {
            position.x = rightEdge
        }
        
        let dx = touch.x - position.x
        let mag = abs(dx)
        
        if(mag > 5.0 + screenWidthBonus()) {
            position.x += dx / mag * (velocity + screenWidthBonus())
        }
    }
    
    func isInvincible() -> Bool {
        return invincible
    }
    
    func collect() {
        let animation = animateTextures(catchTextures)
        
        playSound(Sounds.caught)
        runAction(animation)
    }
    
    func lifeUp() {
        let animation = animateTextures(oneUpTextures)
        let normalize = SKAction.resizeToWidth(originalWidth, duration: 0.4)
        
        playSound(Sounds.one_up)
        
        runAction(SKAction.group([animation, normalize]))
    }
    
    func goGreen() {
        goShroom(greenTextures, factor: 0.5)
    }
    
    func goPurple() {
        goShroom(purpleTextures, factor: 1.5)
    }
    
    private func goShroom(textures: [SKTexture], factor: CGFloat) {
        let animation = animateTextures(textures)
        let change = SKAction.resizeToWidth(originalWidth * factor, duration: 0.5)
        
        playSound(Sounds.shroom)
        runAction(SKAction.group([animation, change]))
    }
    
    func ouch() {
        invincible = true
        
        let animation = animateTextures(ouchTextures)
        let fadeOut = SKAction.fadeAlphaTo(0.3, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let fadeOutIn = SKAction.repeatAction(SKAction.sequence([fadeOut, fadeIn]), count: 3)
        let ouchAnimation = SKAction.group([animation, fadeOutIn])
        let normalize = SKAction.resizeToWidth(originalWidth, duration: 0.4)
        
        let wait = SKAction.waitForDuration(0.7)
        let removeInvincibility = SKAction.runBlock { self.invincible = false }
        
        playSound(Sounds.ouch)
        runAction(SKAction.sequence([
            SKAction.group([ouchAnimation, normalize]),
            wait, removeInvincibility
            ]))
    }
    
    func frown() {
        let animation = SKAction.animateWithTextures(sadTextures, timePerFrame: 0.07)
        
        self.runAction(animation)
    }
    
    private func idle() {
        let textures = [blinkTextures, [idleTexture]].flatMap { $0 }
        
        let blink = animateTextures(textures)
        let delay = SKAction.waitForDuration(1.0)
        let animation = SKAction.sequence([blink, delay, blink, blink, delay, delay])
        
        self.runAction(SKAction.repeatActionForever(animation))
    }
    
    private func animateTextures(textures: [SKTexture]) -> SKAction {
        return SKAction.animateWithTextures(textures, timePerFrame: 0.05)
    }
    
    private func loadTextures() {
        blinkTextures = (1...3).map { SKTexture(imageNamed: "blink_\($0).png") }
        catchTextures = (1...10).map { SKTexture(imageNamed: "catch_\($0).png") }
        oneUpTextures = (1...10).map { SKTexture(imageNamed: "1up_\($0).png") }
        greenTextures = (1...10).map { SKTexture(imageNamed: "go_green_\($0).png") }
        purpleTextures = (1...10).map { SKTexture(imageNamed: "go_purple_\($0).png") }
        ouchTextures  = (1...10).map { SKTexture(imageNamed: "ouch_\($0).png") }
        sadTextures  = (1...8).map { SKTexture(imageNamed: "sad_\($0).png") }
    }
    
    private func screenWidthBonus() -> CGFloat {
        switch UIScreen.mainScreen().bounds.width {
            
        case 0..<330: return 0
            
        case 330..<380: return 5
            
        case 380..<430: return 10
            
        default: return 12
            
        }
    }
}
