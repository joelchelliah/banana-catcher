import UIKit
import SpriteKit

class Brokenut: Decayable {
    
    init(pos: CGPoint, sizeFactor: CGFloat = 1.0) {
        let texture = SKTexture(imageNamed: "brokenut_1")
        
        super.init(texture: texture, pos: pos)
        
        size.height *= sizeFactor
        size.width *= sizeFactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal override func splat() {
        let textures = (1...13).map { SKTexture(imageNamed: "brokenut_\($0).png") }
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        playSound(self, name: "break.wav")
        runAction(animation)
    }
}
