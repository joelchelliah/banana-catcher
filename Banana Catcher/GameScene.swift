import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var hWidth: CGFloat = 0.0
    
    let ground: Ground = Ground()
    let basketMan: BasketMan = BasketMan()
    let monkey: EvilMonkey = EvilMonkey()
    let scoreLabel: ScoreLabel = ScoreLabel()
    let lives: Lives = Lives()
    
    var touching = false
    var touchLoc = CGPointMake(0, 0)
    
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        hWidth = size.width / 2
        score = 0
        
        adjustGravity()
        addBackgroundImage()
        addScore()
        addLives()
        addEdgeBody()
        addGround()
        addBasketMan()
        addEvilMonkey()
    }
    
    override func update(currentTime: CFTimeInterval) {
        monkey.move(frame.width)
        monkeyThrowsSomething()
        
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
                banana.removeFromParent()
                basketMan.collect()
                updateScore(GamePoints.BananaCaught)
                updateMonkey()
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                throwableHitsGround(banana)
                updateScore(GamePoints.BananaMissed)
                decrementLives()
            }
            else {
                handleUnexpectedContactTest(b1, b2: b2)
            }
        } else if b1.categoryBitMask & CollisionCategories.Coconut != 0  {
            let coconut = b1.node as! Coconut
            
            if b2.categoryBitMask & CollisionCategories.BasketMan != 0 {
                coconut.removeFromParent()
                basketMan.ouch()
                updateScore(GamePoints.CoconutCaught)
                decrementLives()
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                throwableHitsGround(coconut)
            }
            else {
                handleUnexpectedContactTest(b1, b2: b2)
            }
            
        }
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Add game elements
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func adjustGravity() {
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.physicsWorld.contactDelegate = self
    }
    
    private func addBackgroundImage() {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPointMake(CGRectGetMidX(frame), background.size.height / 2)
        background.zPosition = -999
        addChild(background)
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
        ground.position = CGPoint(x: hWidth, y: ground.size.height / 2)
        addChild(ground)
    }
    
    private func addBasketMan() {
        basketMan.position = CGPoint(x: hWidth, y: ground.size.height + 10)
        addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        monkey.position = CGPoint(x: hWidth, y: frame.height - 130)
        addChild(monkey)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Update states
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func updateScore(amount: Int) {
        score += amount
        scoreLabel.text = "Score: \(score)"
    }
    
    private func updateMonkey() {
        let level = monkey.currentLevel()
        
        monkey.enrage()
        
        if monkey.currentLevel() > level {
            monkey.disable()
            
            monkey.throwTantrum()
            
            let center = SKAction.moveToX(hWidth, duration: 0.5)
            let frenzy = monkeyCoconutFrenzy()
            let enable = SKAction.runBlock { self.monkey.enable() }
            
            monkey.runAction(SKAction.sequence([center, frenzy, enable]))
        }
    }

    private func decrementLives() {
        if lives.isEmpty() {
            monkey.disable()
            
            let wait = SKAction.waitForDuration(0.3)
            let endGame = SKAction.runBlock { self.gameOver() }
            
            self.runAction(SKAction.sequence([wait, endGame]))
        }
        else {
            lives.ouch()
        }
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Triggerable actions
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func monkeyThrowsSomething() {
        if monkey.isAbleToThrow() {
            
            let item: Throwable = monkey.getTrowable()
            let throwRange = CGFloat(arc4random_uniform(13)) - 6.0

            item.position = CGPoint(x: monkey.position.x, y: monkey.position.y)
            
            addChild(item)
            
            item.physicsBody?.velocity = CGVectorMake(0,0)
            item.physicsBody?.applyImpulse(CGVectorMake(throwRange, item.throwForceY()))
        }
    }
    
    private func monkeyCoconutFrenzy() -> SKAction {
        let level = monkey.currentLevel()
        let maxX = 14
        let step = 2 * maxX / level
        let numCoconuts = monkey.currentLevel() / 2 + 1
        let fromLeft = (1...numCoconuts).map { createThrowAction(-maxX, step: step, i: $0) }
        let fromRight = (1...numCoconuts).map { createThrowAction(maxX, step: -step, i: $0) }

        let coconuts = [fromLeft, fromRight].flatMap { $0 }
        let delays = (1...coconuts.count + 1).map { _ in SKAction.waitForDuration(0.5) }
        let frenzy = zip(coconuts, delays).flatMap { [$0, $1] }
        
        return SKAction.sequence(frenzy)
    }
    
    private func createThrowAction(start: Int, step: Int, i: Int) -> SKAction {
    
        return SKAction.runBlock {
            
            let throwX = CGFloat(start + step * i)
            let coconut = Coconut()
            coconut.position = self.monkey.position
            
            self.addChild(coconut)
            
            coconut.physicsBody?.velocity = CGVectorMake(0,0)
            coconut.physicsBody?.applyImpulse(CGVectorMake(throwX, coconut.throwForceY()))
        }
    }
    
    private func throwableHitsGround(item: Throwable) {
        if let banana = item as? Banana {
            let splatBanana = SplatBanana(pos: CGPointMake(banana.position.x, ground.size.height + 5))
            
            addChild(splatBanana)
            banana.removeFromParent()
        } else if let coconut = item as? Coconut {
            let brokenut = Brokenut(pos: CGPointMake(coconut.position.x, ground.size.height + 5))
            
            addChild(brokenut)
            coconut.removeFromParent()
        } else {
            print("Unexpected item (\(item)) hit the ground!")
        }
    }
    
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Dun dun duuuun!
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func gameOver() {        
        let scene = GameOverScene(size: size)
        scene.scaleMode = scaleMode
        
        let transitionType = SKTransition.flipVerticalWithDuration(0.5)
        view?.presentScene(scene,transition: transitionType)
    }
    
    private func handleUnexpectedContactTest(b1: SKPhysicsBody, b2: SKPhysicsBody) {
        print("Unexpected contant test: (\(b1), \(b2))")
    }
}
