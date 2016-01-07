import UIKit
import SpriteKit

class Superbroke: Decayable {
    
    init(pos: CGPoint, sizeFactor: CGFloat = 1.0) {
        super.init(texture: Textures.superBrokeIdle, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let animation = SKAction.animateWithTextures(Textures.superBrokeBreak, timePerFrame: 0.05)
        
        playSound(Sounds.supersmash)
        runAction(animation)
    }
}
