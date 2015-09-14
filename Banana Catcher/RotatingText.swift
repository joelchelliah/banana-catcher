import UIKit
import SpriteKit

class RotatingText: SKLabelNode {
    
    func setTextFontSizeAndRotate(theText: String, theFontSize: CGFloat){
        self.text = theText;
        self.fontSize = theFontSize
        
        let rotSequence = SKAction.sequence([
            SKAction.rotateByAngle(0.1, duration: 3),
            SKAction.rotateByAngle(-0.2, duration: 6),
            SKAction.rotateByAngle(0.1, duration: 3)])
        
        let rotForever = SKAction.repeatActionForever(rotSequence)
        self.runAction(rotForever)
    }
}
