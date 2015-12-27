import UIKit
import SpriteKit

class TutorialLabel: GameLabel {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init(text: "How to play")
        
        self.position = CGPointMake(x, y)
        self.fontSize = 30
        self.alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
