import UIKit
import SpriteKit

class ScoreboardLabel: SKLabelNode {
    
    init(name: String, size: CGFloat = 30, x: CGFloat, y: CGFloat) {
        super.init()
        
        text = name
        fontSize = size
        position = CGPointMake(x, y)
        
        horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        color = SKColor.whiteColor()
        fontName = gameFont
        
        alpha = 0
        runAction(SKAction.fadeAlphaTo(0.7, duration: 3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
