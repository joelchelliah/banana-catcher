import UIKit
import SpriteKit

class Banana: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "banana")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Banana)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
