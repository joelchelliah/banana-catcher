import UIKit
import SpriteKit

class Heart: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "heart")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Heart)
        
        // Doesn't work!
        //self.physicsBody?.linearDamping *= 0.005
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 8.0
    }
}
