import UIKit
import SpriteKit

class BasketManMenu: SKSpriteNode {
    
    private var idleTexture = Textures.basketManIdleMenu
    private var blinkTextures = Textures.basketManBlinkMenu
    private var jumpTextures = Textures.basketManCatchMenu
    
    init() {
        super.init(texture: idleTexture, color: SKColor.clearColor(), size: idleTexture.size())
                
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animate() {
        
        let blink = blinkAnimation()
        let delay = SKAction.waitForDuration(1.0)
        let jump = SKAction.animateWithTextures(jumpTextures, timePerFrame: 0.05)
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([blink, delay, jump])))
    }
    
    private func blinkAnimation() -> SKAction {
        let blink = SKAction.animateWithTextures(blinkTextures, timePerFrame: 0.05)
        let delay = SKAction.waitForDuration(0.5)
        
        return SKAction.sequence([delay, blink, delay, delay, blink, blink, delay])
    }
}
