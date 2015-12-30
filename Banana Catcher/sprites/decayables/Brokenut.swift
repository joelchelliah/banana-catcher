import UIKit
import SpriteKit

class Brokenut: Decayable {
    
    init(pos: CGPoint) {
        let texture = SKTexture(imageNamed: "brokenut_1")
        
        super.init(texture: texture, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let textures = (1...12).map { SKTexture(imageNamed: "brokenut_\($0).png") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        playSound(Sounds.smash)
        runAction(animation)
    }
}
