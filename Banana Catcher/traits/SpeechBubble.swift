import Foundation
import SpriteKit

protocol SpeechBubble {
    func setSpeechBubble(bubble: SKSpriteNode)
}

extension SpeechBubble where Self: SKScene {
    
    func showSpeechBubble(textures: [SKTexture]) {
        let bubble = SKSpriteNode(texture: textures.first)
        bubble.zPosition = -500
        
        let wait = SKAction.waitForDuration(1.0)
        let show = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        let hide = SKAction.animateWithTextures(textures.reverse(), timePerFrame: 0.05)
        let remove = SKAction.removeFromParent()
        
        bubble.runAction(SKAction.sequence([show, wait, hide, remove]))
        
        setSpeechBubble(bubble)
    }
}
