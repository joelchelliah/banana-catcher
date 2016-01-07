import UIKit
import SpriteKit

class Brokenut: Decayable {
    
    init(pos: CGPoint) {
        let texture = Textures.brokenutIdle
        
        super.init(texture: texture, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let animation = SKAction.animateWithTextures(Textures.brokenutBreak, timePerFrame: 0.05)
        
        playSound(Sounds.smash)
        runAction(animation)
    }
}
