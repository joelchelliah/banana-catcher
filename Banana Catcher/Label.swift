import UIKit
import SpriteKit

class Label: SKLabelNode {
    
    init(name: String, size: CGFloat = 30, x: CGFloat, y: CGFloat, color: SKColor = SKColor.whiteColor()) {
        super.init()
        horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        fontName = gameFont
        text = name
        fontSize = size
        position = CGPointMake(x, y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
