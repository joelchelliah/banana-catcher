import UIKit
import SpriteKit

class CollectPointLabel: SKLabelNode {
    init(points: Int, x: CGFloat, y: CGFloat) {
        super.init()
        position = CGPointMake(x, y)
        fontName = "Courier Bold"
        fontSize = 20
        alpha = 0.8
        
        if points > 0 {
            text = "+ \(points)"
            fontColor = UIColor.whiteColor()
        } else {
            text = "- \(abs(points))"
            fontColor = UIColor.redColor()
        }
        
        let ascend = SKAction.moveToY(position.y + 20, duration: 0.5)
        let fade = SKAction.fadeAlphaTo(0, duration: 0.5)
        let ascendWhileFading = SKAction.group([ascend, fade])
        let remove = SKAction.runBlock { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([ascendWhileFading, remove]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
