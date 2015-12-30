import UIKit
import SpriteKit

class SplatBanana: Decayable {

    init(pos: CGPoint) {
        let texture = SKTexture(imageNamed: "banana_splat_1")

        super.init(texture: texture, pos: pos)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let textures = (1...5).map { SKTexture(imageNamed: "banana_splat_\($0).png") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        playSound(Sounds.splat)
        runAction(animation)
    }
}
