import UIKit
import SpriteKit

class Lives: SKSpriteNode {
    
    private var hearts: [SKSpriteNode] = [SKSpriteNode]()
    private var numLives: Int = 3

    init() {
        let texSize = SKTexture(imageNamed: "heart").size()
        let size = CGSize(width: texSize.width * CGFloat(numLives), height: texSize.height)
        
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        
        drawHearts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isFull() -> Bool {
        return numLives >= 3
    }
    
    func isEmpty() -> Bool {
        return numLives == 0
    }
    
    func down() {
        numLives -= 1
        
        let drawAction = SKAction.runBlock { self.drawHearts() }
        let delay = SKAction.waitForDuration(0.1)
        let blinkAtion = SKAction.runBlock { self.blinkHearts() }
        
        runAction(SKAction.sequence([blinkAtion, delay, drawAction]))
    }
    
    func up() {
        if numLives == 3 { return }
        
        numLives += 1
        
        let drawAction = SKAction.runBlock { self.drawHearts() }
        let delay = SKAction.waitForDuration(0.1)
        let blinkAtion = SKAction.runBlock { self.blinkHearts() }
        
        runAction(SKAction.sequence([drawAction, delay, blinkAtion]))
    }
    
    private func drawHearts() {
        hearts.removeAll()
        removeAllChildren()
        
        if numLives > 0 {
            for i in 0...(numLives - 1) {
                let heart = makeHeart()
                heart.position = CGPoint(x: CGFloat(i) * heart.texture!.size().width, y: 0)
            
                hearts.append(heart)
                addChild(heart)
            }
        }
    }
    
    private func blinkHearts() {
        let fadeOutAction = SKAction.fadeOutWithDuration(0.2)
        let fadeInAction = SKAction.fadeInWithDuration(0.2)
        let fadeOutInAction = SKAction.repeatAction(SKAction.sequence([fadeOutAction,fadeInAction]), count: 3)
        
        runAction(fadeOutInAction)
    }
    
    private func makeHeart() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "heart")
        
        return SKSpriteNode(texture: texture, color: SKColor.clearColor(), size: texture.size())
    }
}
