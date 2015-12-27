import UIKit
import SpriteKit

class InfoLabel: SKLabelNode {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init()
        position = CGPointMake(x, y)
        fontName = gameFont
        text = ""
        color = UIColor.whiteColor()
        fontSize = 20
        alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeText(text: String) {
        self.alpha = 0
        self.text = text
        
        let fadeIn = SKAction.fadeAlphaTo(0.8, duration: 1.0)
        let grow = SKAction.scaleBy(1.1, duration: 0.2)
        let shrink = SKAction.scaleBy(0.9, duration: 0.3)
        
        self.runAction(SKAction.group([fadeIn, SKAction.sequence([grow, shrink])]))
    }
}
