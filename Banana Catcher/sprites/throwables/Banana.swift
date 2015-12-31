import UIKit
import SpriteKit

class Banana: Throwable {
    
    init(withThrowSound: Bool = true) {
        let texture = SKTexture(imageNamed: "banana")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Banana)
        
        if withThrowSound { withSound() }
    }
    
    class func spawnAt(pos: CGPoint) -> Banana {
        let banana = Banana(withThrowSound: false)
        banana.position = pos
        
        return banana
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 10.0
    }
}
