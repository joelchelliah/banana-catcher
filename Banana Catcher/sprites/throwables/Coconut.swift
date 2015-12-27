import UIKit
import SpriteKit

class Coconut: Throwable {
    
    init(withThrowSound: Bool = true) {
        let texture = SKTexture(imageNamed: "coconut")
        super.init(texture: texture, size: texture.size(), categoryBitMask: CollisionCategories.Coconut)
        
        if withThrowSound { withSound() }
    }
    
    class func spawnAt(pos: CGPoint) -> Coconut {
        let coconut = Coconut(withThrowSound: false)
        coconut.position = pos
        
        return coconut
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func throwForceY() -> CGFloat {
        return 19.0
    }
}
