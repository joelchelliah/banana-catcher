import UIKit
import SpriteKit

class Heart: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "heart")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Heart)
        
        self.size.height *= 1.5
        self.size.width *= 1.5
        
        withSound()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 8.0
    }
}
