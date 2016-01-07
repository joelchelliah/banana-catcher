import UIKit
import SpriteKit

class Purplemush: Throwable {
    
    init() {
        let texture = Textures.mushPurple
        
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.PurpleMush)
        
        withSound(Sounds.specialToss)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 16.0
    }
}
