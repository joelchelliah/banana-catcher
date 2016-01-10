import UIKit
import SpriteKit

class EvilMonkey: SKSpriteNode, ItemThrower {
    
    private var disabled: Bool = false
    
    private var flyingTextures = Textures.monkeyFlying
    private var angryTextures = Textures.monkeyAngry
    private var reallyAngryTextures = Textures.monkeyReallyAngry
    
    private let angerEmitter = SKEmitterNode(fileNamed: "Anger")!
    private let angerEffect = SKEffectNode()
    
    private let madnessEmitter = SKEmitterNode(fileNamed: "Madness")!
    private let madnessEffect = SKEffectNode()
    
    init() {
        let texture = flyingTextures.first!
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.usesPreciseCollisionDetection = false

        self.physicsBody?.categoryBitMask = CollisionCategories.EvilMonkey
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        
        animate()
        activateCooldown()
        initAngerEffects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Rage logic
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var rage: Int = 0
    private var requiredRage: Int = 3
    private var level: Int = 0
    private var vLevel: Int = 0
    
    func currentLevel() -> Int {
        return 5 * vLevel + level
    }
    
    func enrage() {
        rage += 1
        
        if rage >= requiredRage {
            let requiredRageRandomFactor = Int(arc4random_uniform(3))
            
            requiredRage += requiredRageRandomFactor + 1
            rage = 0
            level += 1
        }
        
        if level == 5 {
            vLevel += 1
            level = 0
            requiredRage = vLevel + 3
        }
        
        print("level: \(level), vLevel: \(vLevel), currentLevel: \(currentLevel())")
    }
    
    func throwTantrum(darkening: () -> Void) {
        let hasReachedPuberty = currentLevel() >= 5
        
        playSound(Sounds.angry)
        
        if hasReachedPuberty {
            darkening()
            burstIntoFlames()
        }
        
        let textures = hasReachedPuberty ? reallyAngryTextures : angryTextures
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        self.runAction(animation)
    }
    
    private func burstIntoFlames() {
        let lvl = currentLevel()
        let above9 = lvl > 9
        let beserkable = lvl % 5 == 0 || lvl % 3 == 0
        
        if above9 && beserkable {
            madnessEmitter.hidden = false
            madnessEmitter.numParticlesToEmit += 150
            madnessEmitter.resetSimulation()
        }
        
        angerEmitter.hidden = false
        angerEmitter.resetSimulation()
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
    
    func bounce() {
        let yPos = position.y
        let up = SKAction.moveToY(yPos + 20, duration: 0.1)
        let down = SKAction.moveToY(yPos, duration: 0.2)
        
        runAction(SKAction.sequence([up, down]))
    }
    
    private func updateStep() {
        if step < 1.0 {
            let diceRollHit = Int(arc4random_uniform(6)) == 1
            
            if diceRollHit {
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
        position.x += direction * (step + screenWidthBonus())
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Throwing and cooldown logic
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var canThrow: Bool = false
    
    private var coconutChance: Int = 0;
    private var supernutChance: Int = 0;
    
    private var heartChance: Int = 0;
    
    func isAbleToThrow() -> Bool {
        if disabled { return false }
        
        if canThrow {
            activateCooldown()
            canThrow = false
            return true
        } else {
            return false
        }
    }
    
    private func activateCooldown() {
        NSTimer.scheduledTimerWithTimeInterval(
            coolDown(),
            target: self,
            selector: "updateCanThrow",
            userInfo: nil,
            repeats: false)
    }
    
    private func coolDown() -> Double {
        let lvl = currentLevel()
        
        if lvl > 24 {
            return 0.3
        } else {
            return [
                2.0, 1.5, 1.3, 1.1, 0.9, // 0  - 4
                1.4, 1.2, 1.1, 0.9, 0.8, // 5  - 9
                1.2, 1.0, 0.9, 0.8, 0.7, // 10 - 14
                1.0, 0.8, 0.7, 0.6, 0.5, // 15 - 19
                0.8, 0.7, 0.6, 0.5, 0.4  // 20 - 24
                ][lvl]
        }
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
    
    private func initAngerEffects() {
        angerEmitter.hidden = true
        madnessEmitter.hidden = true
        
        angerEffect.addChild(angerEmitter)
        madnessEffect.addChild(madnessEmitter)
        
        addChild(angerEffect)
        addChild(madnessEffect)
    }
    
    private func screenWidthBonus() -> CGFloat {
        switch UIScreen.mainScreen().bounds.width {
            
        case 0..<330: return 0
            
        case 330..<380: return 3
            
        case 380..<430: return 6
            
        default: return 9
            
        }
    }
}
