import UIKit
import SpriteKit

class Lives: SKSpriteNode {
    
    var hearts: [SKSpriteNode] = [SKSpriteNode]()
    let numLives: Int = 1

    init() {
        let texture = SKTexture(imageNamed: "heart")
        let texSize = texture.size()
        
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: texSize.width * CGFloat(numLives), height: texSize.height))
        
        for i in 0...(numLives - 1) {
            let heart = SKSpriteNode(texture: texture, color: SKColor.clearColor(), size: texSize)
            heart.position = CGPoint(x: CGFloat(i) * texSize.width, y: 0)
            
            hearts.append(heart)
            addChild(heart)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isEmpty() -> Bool {
        return hearts.isEmpty
    }
    
    func ouch() {
        let heart = hearts.removeFirst()
        
        let fadeOutAction = SKAction.fadeOutWithDuration(0.2)
        let fadeInAction = SKAction.fadeInWithDuration(0.2)
        let fadeOutInAction = SKAction.repeatAction(SKAction.sequence([fadeOutAction,fadeInAction]), count: 2)
        let removeHeartAction = SKAction.runBlock {
            heart.removeFromParent()
        }
        
        heart.runAction(SKAction.sequence([fadeOutInAction, fadeOutAction, removeHeartAction]))
    }
}
