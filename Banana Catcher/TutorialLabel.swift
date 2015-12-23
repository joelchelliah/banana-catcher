import UIKit
import SpriteKit

class TutorialLabel: SKLabelNode {
    
    init(x: CGFloat, y: CGFloat, zPosition: CGFloat) {
        super.init()
        position = CGPointMake(x, y)
        fontName = gameFont
        text = "How to play"
        color = UIColor.whiteColor()
        fontSize = 30
        alpha = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
