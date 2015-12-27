import UIKit
import SpriteKit

class GameOverLabel: GameLabel {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init(text: "Game Over")
        
        self.position = CGPointMake(x, y)
        self.fontSize = 35
        
        fadeIn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func fadeIn() {
        self.alpha = 0
        
        self.runAction(SKAction.fadeAlphaTo(0.8, duration: 8))
    }
}
