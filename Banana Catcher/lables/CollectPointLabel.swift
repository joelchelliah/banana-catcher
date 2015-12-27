import UIKit
import SpriteKit

class CollectPointLabel: SKLabelNode {
    
    private let plusColor = UIColor.whiteColor()
    private let minusColor = UIColor.redColor()
    
    init(points: Int, x: CGFloat, y: CGFloat) {
        super.init()
        position = CGPointMake(x, y)
        fontName = "Georgia Bold"
        fontSize = 25
        alpha = 0.8
        
        if points > 0 {
            text = "+\(points)"
            fontColor = plusColor
        } else {
            text = "\(points)"
            fontColor = minusColor
        }
        
        let d1 = 0.2
        let d2 = 0.6
        let ascendWhileFading = SKAction.group([
            SKAction.moveToY(position.y + 25, duration: d1),
            SKAction.fadeAlphaTo(0.3, duration: d1)
            ])
        let descendWhileFading = SKAction.group([
            SKAction.moveToY(position.y - 10, duration: d2),
            SKAction.fadeAlphaTo(0, duration: d2)
            ])
        let remove = SKAction.runBlock { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([ascendWhileFading, descendWhileFading, remove]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
