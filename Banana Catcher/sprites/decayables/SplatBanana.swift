import UIKit
import SpriteKit

class SplatBanana: Decayable {

    init(pos: CGPoint) {
        let texture = Textures.bananaSplatIdle

        super.init(texture: texture, pos: pos)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let animation = SKAction.animateWithTextures(Textures.bananaSplatBreak, timePerFrame: 0.05)
        
        playSound(Sounds.splat)
        runAction(animation)
    }
}
