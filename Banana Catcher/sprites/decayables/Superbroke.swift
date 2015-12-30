import UIKit
import SpriteKit

class Superbroke: Decayable {
    
    init(pos: CGPoint, sizeFactor: CGFloat = 1.0) {
        let texture = SKTexture(imageNamed: "superbroke_1.png")
        
        super.init(texture: texture, pos: pos)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let textures = (1...12).map { SKTexture(imageNamed: "superbroke_\($0).png") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        playSound(Sounds.supersmash)
        runAction(animation)
    }
}
