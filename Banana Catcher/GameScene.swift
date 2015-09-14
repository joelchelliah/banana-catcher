import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ground: Ground = Ground()
    let basketMan: BasketMan = BasketMan()
    let monkey: EvilMonkey = EvilMonkey()
    
    var touching = false
    var touchLoc = CGPointMake(0, 0)
    
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        addGround()
        addBasketMan()
        addEvilMonkey()
        
        invokeThrowBananas()
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (touching) { moveBasketMan() }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = true
        touchLoc = touches.first!.locationInNode(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLoc = touches.first!.locationInNode(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
    }
    
    
    /* Add game elements */
    
    private func addGround() {
        ground.position = CGPoint(x: CGRectGetMidX(self.frame), y: ground.size.height / 2 - 10)
        addChild(ground)
    }
    
    private func addBasketMan() {
        basketMan.position = CGPoint(x: CGRectGetMidX(self.frame), y: ground.size.height + 10)
        addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        monkey.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - 130)
        addChild(monkey)
    }
    
    
    /* game element actions */
    
    private func moveBasketMan() {
        let dx = touchLoc.x - basketMan.position.x
        let mag = abs(dx)
        
        if(mag > 3.0) {
            basketMan.position.x += dx / mag * 5.0
        }
    }
    
    private func invokeThrowBananas() {
        let throwIt = SKAction.runBlock() { self.throwBanana() }
        let wait = SKAction.waitForDuration(1.0)

        runAction(SKAction.repeatActionForever(SKAction.sequence([throwIt, wait])))
    }
    
    private func throwBanana() {
        let banana: Banana = Banana()
        banana.position = CGPoint(x: monkey.position.x, y: monkey.position.y)
        addChild(banana)
        
        let throwRange = CGFloat(arc4random_uniform(11)) - 5.0
        
        banana.physicsBody?.velocity = CGVectorMake(0,0)
        banana.physicsBody?.applyImpulse(CGVectorMake(throwRange, 10))
    }
}
