import UIKit
import SpriteKit

class BasketManMenu: SKSpriteNode {
    
    private var idleTexture = SKTexture(imageNamed: "idle_menu.png")
    private var blinkTextures = [SKTexture]()
    private var jumpTextures = [SKTexture]()
    
    init() {
        super.init(texture: idleTexture, color: SKColor.clearColor(), size: idleTexture.size())
                
        loadTextures()
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
    
    private func loadTextures() {
        blinkTextures = (1...4).map { SKTexture(imageNamed: "blink_menu_\($0).png") }
        jumpTextures.appendContentsOf((1...12).map { SKTexture(imageNamed: "catch_menu_\($0).png") })
        jumpTextures.appendContentsOf((1...15).map { SKTexture(imageNamed: "catch_menu_\($0).png") })
    }
}
