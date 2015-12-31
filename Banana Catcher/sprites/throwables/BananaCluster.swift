import UIKit
import SpriteKit

class BananaCluster: Throwable {
    
    init() {
        let texture = SKTexture(imageNamed: "banana_cluster")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.BananaCluster)
        
        withSound()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 14.0
    }
}
