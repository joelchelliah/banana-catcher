import UIKit
import SpriteKit

class SplatBananaCluster: Decayable {
    
    init(pos: CGPoint) {
        let texture = Textures.bananaClusterSplatIdle
        
        super.init(texture: texture, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let animation = SKAction.animateWithTextures(Textures.bananaClusterSplatBreak, timePerFrame: 0.05)
        
        playSound(Sounds.splat)
        runAction(animation)
    }
}
