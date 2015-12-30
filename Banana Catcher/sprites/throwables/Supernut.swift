import UIKit
import SpriteKit

class Supernut: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "supernut")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Supernut)
        
        withSound(Sounds.supernut)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 19.0
    }
}
