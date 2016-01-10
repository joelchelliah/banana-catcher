import Foundation
import SpriteKit

protocol ThrowSupport {}

extension ThrowSupport where Self: GameScene {
    
    func monkeyThrowsSomething() {
        if monkey.isAbleToThrow() {
            
            let item: Throwable = monkey.getTrowable()
            let throwRange = CGFloat(randomBalanced(13))
            
            item.position = CGPoint(x: monkey.position.x, y: monkey.position.y)
            
            addChild(item)
            
            item.physicsBody?.velocity = CGVectorMake(0,0)
            item.physicsBody?.applyImpulse(CGVectorMake(throwRange, item.throwForceY()))
            
            monkey.bounce()
        }
    }
    
    func throwSpawnedItem(spawn: Throwable) {
        let yForce = spawn.throwForceY()
        
        let throwX = CGFloat(randomBalanced(25))
        let throwY = yForce + CGFloat(random(Int(yForce)))
        
        addChild(spawn)
        
        spawn.physicsBody?.velocity = CGVectorMake(0,0)
        spawn.physicsBody?.applyImpulse(CGVectorMake(throwX, throwY))
    }
    
    func coconutFrenzyActions() -> SKAction {
        let level = monkey.currentLevel()
        assert(level > 0, "Monkey's level should be above 0!")
        
        let maxX: Float = 8.0
        let step: Float = 2.0 * Float(maxX) / Float(level)
        
        var numCoconuts = 1
        if level < 14 { numCoconuts = level % 3 }
        if numCoconuts == 0 { numCoconuts = 2 }
        
        let fromLeft = (1...numCoconuts).map { frenzyThrowAction(-maxX, step: step, i: $0 - 1) }
        let fromRight = (1...numCoconuts).map { frenzyThrowAction(maxX, step: -step, i: $0 - 1) }
        
        let coconuts = zip(fromLeft, fromRight).flatMap { [$0, $1] }
        let delay = SKAction.waitForDuration(0.2)
        let delays = (1...coconuts.count).map { _ in delay }
        let frenzy = zip(coconuts, delays).flatMap { [$0, $1] }
        
        return SKAction.sequence(frenzy + [delay])
    }
    
    private func frenzyThrowAction(start: Float, step: Float, i: Int) -> SKAction {
        let variance: Float = Float(arc4random_uniform(4))
        let throwX = CGFloat(start + step * Float(i) + variance)
        
        return SKAction.runBlock {
            let throwable = self.getFrenzyThrowable()
            
            throwable.position = self.monkey.position
            
            self.addChild(throwable)
            
            throwable.physicsBody?.velocity = CGVectorMake(0,0)
            throwable.physicsBody?.applyImpulse(CGVectorMake(throwX, throwable.throwForceY()))
        }
    }
    
    private func getFrenzyThrowable() -> Throwable {
        let item = monkey.getTrowable()
        
        switch item {
        
        case is Banana: return Coconut()
        
        case is BananaCluster: return Supernut()
            
        default: return item
        }
    }
}
