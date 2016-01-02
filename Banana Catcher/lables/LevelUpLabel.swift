import UIKit
import SpriteKit

class LevelUpLabel: GameLabel {
    
    init(x: CGFloat, y: CGFloat) {
        super.init()
        
        self.position = CGPointMake(x, y)
        self.fontSize = 20
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show(level: Int) {
        text = "Level \(level)"
        
        let y = position.y
        
        let fadeIn = SKAction.fadeAlphaTo(0.8, duration: 0.4)
        let fadeOut = SKAction.fadeAlphaTo(0, duration: 0.8)
        let ascend = SKAction.moveByX(0, y: 10, duration: 1.2)
        
        let ascendWhileFading = SKAction.group([SKAction.sequence([fadeIn, fadeOut]), ascend])
        let resetPos = SKAction.runBlock { self.position.y = y }
        
        self.runAction(SKAction.sequence([ascendWhileFading, resetPos]))
    }
}
