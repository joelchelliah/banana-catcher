import UIKit
import SpriteKit

class InfoLabel: GameLabel {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init()
        
        self.position = CGPointMake(x, y)
        self.color = UIColor.whiteColor()
        self.fontSize = 20
        self.alpha = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func clear() {
        self.text = ""
    }
    
    func changeText(text: String) {
        self.alpha = 0
        self.text = text
        
        let fadeIn = SKAction.fadeAlphaTo(0.8, duration: 1.0)
        let grow = SKAction.scaleBy(1.2, duration: 0.2)
        let shrink = SKAction.scaleBy(0.8, duration: 0.4)
        
        self.runAction(SKAction.group([
            fadeIn,
            SKAction.sequence([grow, shrink])
            ]))
    }
}
