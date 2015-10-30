import UIKit
import SpriteKit

class Throwable: SKSpriteNode {
    
    init(texture: SKTexture, size: CGSize,  categoryBitMask: UInt32) {
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        self.physicsBody?.categoryBitMask = categoryBitMask
        self.physicsBody?.contactTestBitMask = CollisionCategories.BasketMan | CollisionCategories.Ground
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.EdgeBody
        
        getThrown()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func throwForceY() -> CGFloat {
        fatalError("throwForce has not been overridden!")
    }
    
    
    private func getThrown() {
        let rotDir = [-1.0, 1.0][Int(arc4random_uniform(2))]
        let rotSpeed = 2.0 / Double(arc4random_uniform(5) + 1)
        let rot = SKAction.rotateByAngle(CGFloat(rotDir * M_PI) * 2.0, duration: rotSpeed)
        
        let sound = SKAction.playSoundFileNamed("throw.wav", waitForCompletion: false)
        let animation = SKAction.repeatActionForever(rot)
        
        self.runAction(SKAction.sequence([sound, animation]))
    }
}
