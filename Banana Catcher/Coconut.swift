import UIKit
import SpriteKit

class Coconut: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "coconut")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Coconut)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func decay() {
        let wait = SKAction.waitForDuration(1.0)
        let fadeAway = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        let remove = SKAction.runBlock() { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([wait, fadeAway, remove]))
    }
}
