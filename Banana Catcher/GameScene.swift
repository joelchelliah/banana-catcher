import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        addGround()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       /* Called when a touch begins */

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func addGround() {
        let tex = SKTexture(imageNamed: "ground")
        let ground = SKSpriteNode(texture: tex, color: SKColor.clearColor(), size: tex.size())
        
        ground.position = CGPoint(x: CGRectGetMidX(self.frame), y: ground.size.height / 2 - 10)
        addChild(ground)
    }
}
