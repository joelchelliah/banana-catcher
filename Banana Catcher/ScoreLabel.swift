import UIKit
import SpriteKit

class ScoreLabel: SKLabelNode {

    override init() {
        super.init()
        text = "Score: 0"
        color = SKColor.whiteColor()
        fontName = gameFont
        fontSize = 22
        alpha = 0.75
        horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
