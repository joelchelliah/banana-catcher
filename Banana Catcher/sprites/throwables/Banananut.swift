import UIKit
import SpriteKit

class Banananut: Throwable {
    
    init(withThrowSound: Bool = true) {
        let texture = SKTexture(imageNamed: "banananut")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Banananut)
        
        withSound()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 19.0
    }
}
