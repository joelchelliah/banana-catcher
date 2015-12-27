import UIKit
import SpriteKit

class ScoreLabel: GameLabel {

    private let prefix = "Score:"
    
    init() {
        super.init()
        
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.fontSize = 22
        self.alpha = 0.75
        
        setScore(0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setScore(score: Int) {
        self.text = "\(prefix) \(score)"
    }
}
