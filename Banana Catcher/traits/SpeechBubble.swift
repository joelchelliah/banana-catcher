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

struct SpeechBubbles {
    static let adsRestored = range.map { SKTexture(imageNamed: "ads_restored_\($0).png") }
    static let hello = range.map { SKTexture(imageNamed: "hello_\($0).png") }
    static let pleaseWait = range.map { SKTexture(imageNamed: "please_wait_\($0).png") }
    static let thankYou = range.map { SKTexture(imageNamed: "thank_you_\($0).png") }
    static let sniffle = range.map { SKTexture(imageNamed: "sniffle_\($0).png") }
    
    private static let range = (1...7)
}
