import UIKit
import SpriteKit

class Greenmush: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "greenmush")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.GreenMush)
        
        withSound(Sounds.specialToss)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 16.0
    }
}
