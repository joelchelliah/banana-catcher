import UIKit
import SpriteKit

class Supernut: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "coconut")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Supernut)
        
        size.height *= 1.5
        size.width *= 1.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 19.0
    }
}
