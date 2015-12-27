import UIKit
import SpriteKit

class ScoreboardLabel: GameLabel {
    
    init(name: String, size: CGFloat, x: CGFloat, y: CGFloat) {
        super.init(text: name)
        
        self.fontSize = size
        self.position = CGPointMake(x, y)
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        fadeIn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func fadeIn() {
        self.alpha = 0
        self.runAction(SKAction.fadeAlphaTo(0.7, duration: 3))
    }
}
