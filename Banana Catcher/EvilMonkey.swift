import UIKit
import SpriteKit

class EvilMonkey: SKSpriteNode {
    
    private var disabled: Bool = false
    
    private var flyingTextures = [SKTexture]()
    private var angryStartTextures = [SKTexture]()
    private var angryMidTextures = [SKTexture]()
    private var angryEndTextures = [SKTexture]()
    
    init() {
        let texture = SKTexture(imageNamed: "flying_1.png")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = false

        self.physicsBody?.categoryBitMask = CollisionCategories.EvilMonkey
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        
        loadTextures()
        animate()
        activateCooldown()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Rage logic
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var rage: Int = 0
    private var requiredRage: Int = 5
    private var level: Int = 0
    
    func currentLevel() -> Int {
        return level
    }
    
    func enrage() {
        rage += 1
        
        if rage >= requiredRage {
            rage = 0
            requiredRage += Int(arc4random_uniform(4)) + 1
            level += 1
        }
    }
    
    func throwTantrum() {
        setThrowHeartAbility()

        let angerIndex = Int(arc4random_uniform(4)) + 1
        
        playSound(self, name: "monkey_angry_\(angerIndex).wav")
        
        let start = SKAction.animateWithTextures(angryStartTextures, timePerFrame: 0.05)
        let mid = SKAction.animateWithTextures(angryMidTextures, timePerFrame: 0.05)
        let midExtended = SKAction.repeatAction(mid, count: 4 * level + 10)
        let end = SKAction.animateWithTextures(angryEndTextures, timePerFrame: 0.05)
        
        self.runAction(SKAction.sequence([start, midExtended, end]))
    }
    
    private func setThrowHeartAbility() {
        if level >= 3 {
            canThrowHeartDuringTantrum = true
        }
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Movement logic
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var step: CGFloat = 1.0
    private var direction: CGFloat = -1.0
    
    func move(range: CGFloat) {
        if !disabled {
            updateStep()
            updatePosition(range)
        }
    }
    
    private func updateStep() {
        if step < 1.0 {
            if Int(arc4random_uniform(6)) == 1 {
                step = CGFloat(arc4random_uniform(4))
            }
        } else { step -= 0.05 }
    }
    
    private func updatePosition(range: CGFloat) {
        let halfWidth = size.width / 2
        let safetyDistance: CGFloat = 0.5
        
        if (position.x > range - halfWidth) {
            position.x = range - halfWidth - safetyDistance
            direction = -direction
        }
        
        if (position.x < halfWidth) {
            position.x = halfWidth + safetyDistance
            direction = -direction
        }
        position.x += direction * step
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Throwing and cooldown logic
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var canThrowHeartDuringTantrum: Bool = false
    private var canThrow: Bool = false
    private var coconutFactor: Int = 0;
    
    func isAbleToThrow() -> Bool {
        if disabled { return false }
        
        let couldThrow = canThrow
        if canThrow {
            canThrow = false
            activateCooldown()
        }
        return couldThrow
    }
    
    func getTrowable() -> Throwable {
        let diceRoll = Int(arc4random_uniform(100))
        
        if diceRoll < coconutFactor {
            coconutFactor = 0
            return Coconut()
        } else {
            coconutFactor += coconutFactorInc()
            return Banana()
        }
    }
    
    func canThrowHeart() -> Bool {
        if canThrowHeartDuringTantrum && arc4random_uniform(3) == 1 {
            canThrowHeartDuringTantrum = false
            return true
        } else {
            return false
        }
    }
    
    private func coconutFactorInc() -> Int {
        let factor = 10
        
        return (1 + level) * factor
    }
    
    private func activateCooldown() {
        let factor = 0.2
        let coolDown = 2.0 - Double(level) * factor
        
        NSTimer.scheduledTimerWithTimeInterval(coolDown, target: self, selector: "updateCanThrow", userInfo: nil, repeats: false)
    }
    
    internal func updateCanThrow() {
        canThrow = true
    }
    
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Misc
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func enable() {
        disabled = false
    }
    
    func disable() {
        disabled = true
    }
    
    private func animate() {
        let anim = SKAction.animateWithTextures(flyingTextures, timePerFrame: 0.06)
        
        self.runAction(SKAction.repeatActionForever(anim))
    }
    
    private func loadTextures() {
        flyingTextures = (1...8).map { SKTexture(imageNamed: "flying_\($0).png") }
        angryStartTextures = (1...7).map { SKTexture(imageNamed: "monkey_angry_\($0).png") }
        angryMidTextures = (8...9).map { SKTexture(imageNamed: "monkey_angry_\($0).png") }
        angryEndTextures = (10...15).map { SKTexture(imageNamed: "monkey_angry_\($0).png") }
    }
}
