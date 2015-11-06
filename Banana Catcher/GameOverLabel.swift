import UIKit
import SpriteKit

class GameOverLabel: SKLabelNode {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init()
        position = CGPointMake(x, y)
        fontName = gameFont
        text = "Game Over"
        color = UIColor.whiteColor()
        fontSize = 35
        alpha = 0
        
        
        self.runAction(SKAction.fadeAlphaTo(0.8, duration: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
