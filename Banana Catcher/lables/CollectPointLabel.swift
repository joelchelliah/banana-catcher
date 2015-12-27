import UIKit
import SpriteKit

class CollectPointLabel: GameLabel {
    
    private let plusColor = UIColor.whiteColor()
    private let minusColor = UIColor.redColor()
    
    init(points: Int, x: CGFloat, y: CGFloat) {
        super.init()
        
        self.position = CGPointMake(x, y)
        self.fontSize = 25
        self.alpha = 0.8
        
        setTextAndColor(points)
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setTextAndColor(points: Int) {
        if points > 0 {
            self.text = "+\(points)"
            self.fontColor = plusColor
        } else {
            self.text = "\(points)"
            self.fontColor = minusColor
        }
    }
    
    private func animate() {
        let d1 = 0.2
        let d2 = 0.6
        let ascendY = position.y + 25
        let descendY = position.y + 20
        
        let ascendWhileFading = SKAction.group([
            SKAction.moveToY(ascendY, duration: d1),
            SKAction.fadeAlphaTo(0.4, duration: d1)
            ])
        let descendWhileFading = SKAction.group([
            SKAction.moveToY(descendY, duration: d2),
            SKAction.fadeAlphaTo(0, duration: d2)
            ])
        let remove = SKAction.runBlock { self.removeFromParent() }
        
        self.runAction(SKAction.sequence([ascendWhileFading, descendWhileFading, remove]))
    }
}
