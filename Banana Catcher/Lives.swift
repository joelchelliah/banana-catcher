import UIKit
import SpriteKit

class Lives: SKSpriteNode {
    
    var hearts = [SKSpriteNode]()

    init() {
        let texture = SKTexture(imageNamed: "heart")
        let texSize = texture.size()
        
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: texSize.width * 3, height: texSize.height))
        
        for i in 0...2 {
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
        
        heart.removeFromParent()
    }
}
