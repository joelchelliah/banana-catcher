import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ground: Ground = Ground()
    let basketMan: BasketMan = BasketMan()
    let monkey: EvilMonkey = EvilMonkey()
    let scoreLabel: ScoreLabel = ScoreLabel()
    let lives: Lives = Lives()
    
    var touching = false
    var touchLoc = CGPointMake(0, 0)
    
    override func didMoveToView(view: SKView) {
        print("did move to view")
        
        backgroundColor = bgColor
        adjustGravity()
        addScore()
        addLives()
        addEdgeBody()
        addGround()
        addBasketMan()
        addEvilMonkey()
    }
    
    override func update(currentTime: CFTimeInterval) {
        monkey.move(frame.width)
        if monkey.canThrowBanana() { throwBanana() }
        
        if (touching) { basketMan.move(touchLoc) }
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
    
    
    /* Collision detection */
    
    func didBeginContact(contact: SKPhysicsContact) {
        var b1: SKPhysicsBody
        var b2: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            b1 = contact.bodyA
            b2 = contact.bodyB
        } else {
            b1 = contact.bodyB
            b2 = contact.bodyA
        }
        
        if b1.node?.parent == nil || b2.node?.parent == nil { return }
        
        if b1.categoryBitMask & CollisionCategories.Banana != 0  {
            let banana = b1.node as! Banana
            
            if b2.categoryBitMask & CollisionCategories.BasketMan != 0 {
                
                if !banana.isSplat() {
                    banana.removeFromParent()
                    basketMan.collect()
                    incrementScore()
                }
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                
                if !banana.isSplat() {
                    banana.goSplat()
                    decrementLives()
                }
            }
            else {
                print("Unexpected contant test: (\(b1), \(b2))")
            }
        }
    }
    
    
    /* Add game elements */
    
    private func adjustGravity() {
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.physicsWorld.contactDelegate = self
    }
    
    private func addScore() {
        scoreLabel.position = CGPoint(x: 10, y: frame.height - 30)
        addChild(scoreLabel)
    }
    
    private func addLives() {
        lives.position = CGPoint(x: frame.width - lives.size.width, y: frame.height - 30)
        addChild(lives)
    }
    
    private func addEdgeBody() {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
    }
    
    private func addGround() {
        ground.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height / 2 - 10)
        ground.zPosition = -999
        addChild(ground)
    }
    
    private func addBasketMan() {
        basketMan.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height + 10)
        addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        monkey.position = CGPoint(x: CGRectGetMidX(frame), y: frame.height - 130)
        addChild(monkey)
    }
    
    
    /* Game element actions */
    
    private func throwBanana() {
        let banana: Banana = Banana()
        banana.position = CGPoint(x: monkey.position.x, y: monkey.position.y)
        addChild(banana)
        
        let throwRange = CGFloat(arc4random_uniform(13)) - 6.0
        
        banana.physicsBody?.velocity = CGVectorMake(0,0)
        banana.physicsBody?.applyImpulse(CGVectorMake(throwRange, 8))
    }
    
    private func incrementScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if score % 2 == 0 {
            monkey.enrage()
        }
    }
    
    private func decrementLives() {
        if lives.isEmpty() {
            gameOver()
        }
        else {
            lives.ouch()
        }
    }
    
    private func gameOver() {        
        let scene = GameOverScene(size: size)
        scene.scaleMode = scaleMode
        
        let transitionType = SKTransition.flipVerticalWithDuration(0.5)
        view?.presentScene(scene,transition: transitionType)
    }
}
