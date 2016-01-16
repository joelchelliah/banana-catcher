import UIKit
import SpriteKit

class ShopLabel: GameLabel {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init(text: "Remove Ads")
        
        self.position = CGPointMake(x, y)
        self.fontSize = 30
        
        self.alpha = 0
        self.runAction(SKAction.fadeAlphaTo(0.8, duration: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
