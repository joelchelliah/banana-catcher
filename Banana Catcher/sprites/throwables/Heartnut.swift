import UIKit
import SpriteKit

class Heartnut: Throwable {
    
    init(withThrowSound: Bool = true) {
        let texture = Textures.heartNut
        
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Heartnut)
        
        withSound()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 19.0
    }
}
