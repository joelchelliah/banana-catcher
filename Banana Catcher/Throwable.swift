import UIKit
import SpriteKit

class Throwable: SKSpriteNode {
    
    init(texture: SKTexture, size: CGSize,  categoryBitMask: UInt32) {
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.categoryBitMask = categoryBitMask
        self.physicsBody?.contactTestBitMask = CollisionCategories.BasketMan | CollisionCategories.Ground
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        withRotation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func throwForceY() -> CGFloat {
        fatalError("throwForce has not been overridden!")
    }
    
    
    internal func withSound(sound: String? = nil) {
        let soundPitch = Int(arc4random_uniform(3)) + 1
        
        if let sound = sound {
            playSound(self, name: "\(sound)_\(soundPitch).wav")
        } else {
            playSound(self, name: "throw_\(soundPitch).wav")
        }
    }
    
    private func withRotation() {
        let rotDirection = [-1.0, 1.0][Int(arc4random_uniform(2))]
        let rotSpeed = 2.0 / Double(arc4random_uniform(5) + 1)
        let rot = SKAction.rotateByAngle(CGFloat(rotDirection * M_PI) * 2.0, duration: rotSpeed)
        
        self.runAction(SKAction.repeatActionForever(rot))
    }
}
