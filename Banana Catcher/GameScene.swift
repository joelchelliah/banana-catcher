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
        hWidth = size.width / 2
        score = 0
        
        musicPlayer.change("game_1")
        
        adjustGravity()
        addBackgroundImage()
        addScore()
        addLives()
        addEdgeBody()
        addGround()
        addDoodads()
        addBasketMan()
        addEvilMonkey()
    }
    
    override func update(currentTime: CFTimeInterval) {
        monkey.move(frame.width)
        monkeyThrowsSomething()
        
        let leftEdge = basketMan.size.width / 2
        let rightEdge = size.width - basketMan.size.width / 2
        
        if basketMan.position.x < leftEdge {
            basketMan.position.x = leftEdge
        } else if basketMan.position.x > rightEdge {
            basketMan.position.x = rightEdge
        }
        
        if touching {
            basketMan.move(touchLoc)
        }   
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
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Collision detection
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
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
                let pos = banana.position
                let points = GamePoints.BananaCaught
                
                banana.removeFromParent()
                addChild(CollectPointLabel(points: points, x: pos.x, y: pos.y))
                
                basketMan.collect()
                updateScore(points)
                updateMonkey()
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                let pos = banana.position
                let points = GamePoints.BananaMissed
                
                addChild(CollectPointLabel(points: points, x: pos.x, y: pos.y + 15))
                
                basketMan.frown()
                throwableHitsGround(banana)
                updateScore(points)
                decrementLives()
            }
            else {
                handleUnexpectedContactTest(b1, b2: b2)
            }
        } else if b1.categoryBitMask & CollisionCategories.Coconut != 0  {
            let coconut = b1.node as! Coconut
            
            if b2.categoryBitMask & CollisionCategories.BasketMan != 0 {
                let pos = coconut.position
                let points = GamePoints.CoconutCaught
                
                coconut.removeFromParent()
                addChild(CollectPointLabel(points: points, x: pos.x, y: pos.y))
                
                basketMan.ouch()
                updateScore(points)
                decrementLives()
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                throwableHitsGround(coconut)
            }
            else {
                handleUnexpectedContactTest(b1, b2: b2)
            }
            
        } else if b1.categoryBitMask & CollisionCategories.Supernut != 0  {
            let supernut = b1.node as! Supernut
            
            if b2.categoryBitMask & CollisionCategories.BasketMan != 0 {
                let pos = supernut.position
                let points = GamePoints.SupernutCaught
                
                supernut.removeFromParent()
                addChild(CollectPointLabel(points: points, x: pos.x, y: pos.y))
                
                basketMan.ouch()
                updateScore(points)
                decrementLives()
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                throwableHitsGround(supernut)
            }
            else {
                handleUnexpectedContactTest(b1, b2: b2)
            }
            
        } else if b1.categoryBitMask & CollisionCategories.Heart != 0  {
            let heart = b1.node as! Heart
            
            if b2.categoryBitMask & CollisionCategories.BasketMan != 0 {
                let pos = heart.position
                let points = GamePoints.HeartCaught
                
                heart.removeFromParent()
                addChild(CollectPointLabel(points: points, x: pos.x, y: pos.y))
                
                basketMan.lifeUp()
                updateScore(points)
                incrementLives()
            }
            else if b2.categoryBitMask & CollisionCategories.Ground != 0 {
                throwableHitsGround(heart)
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
    
    private func addDoodads() {
        let bushGenerator = BushGenerator(forScene: self, yBasePos: ground.size.height + 15)
        let cloudGenerator = CloudGenerator(forScene: self)
        
        bushGenerator.generate()
        cloudGenerator.generate()
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
        let levelBefore = monkey.currentLevel()
        monkey.enrage()
        let currentLevel = monkey.currentLevel()
        
        
        if currentLevel > levelBefore {
            if currentLevel == 5 { musicPlayer.change("game_2") }
            
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
            lives.down()
        }
    }
    
    private func incrementLives() {
        lives.up()
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
        
            monkey.bounce()
        }
    }
    
    private func monkeyCoconutFrenzy() -> SKAction {
        let level = monkey.currentLevel()
        assert(level > 0, "Monkey's level should be above 0!")
        
        let maxX: Float = 8.0
        let step: Float = 2.0 * Float(maxX) / Float(level)
        
        var throwSpeedBoost = 0.0
        var numCoconuts = level
        if numCoconuts > 3 {
            throwSpeedBoost = Double(numCoconuts - 3) / (20.0 + Double(numCoconuts))
            numCoconuts = 3
        }
        
        let fromLeft = (1...numCoconuts).map { frenzyThrowAction(-maxX, step: step, i: $0 - 1) }
        let fromRight = (1...numCoconuts).map { frenzyThrowAction(maxX, step: -step, i: $0 - 1) }

        let coconuts = zip(fromLeft, fromRight).flatMap { [$0, $1] }
        let delay = SKAction.waitForDuration(0.4 - throwSpeedBoost)
        let delays = (1...coconuts.count).map { _ in delay }
        let frenzy = zip(coconuts, delays).flatMap { [$0, $1] }
        
        return SKAction.sequence(frenzy + [delay])
    }
    
    private func frenzyThrowAction(start: Float, step: Float, i: Int) -> SKAction {
        let variance: Float = Float(arc4random_uniform(4))
        let throwX = CGFloat(start + step * Float(i) + variance)
        
        return SKAction.runBlock {
            let throwable = self.frenzyThrowable()
            
            throwable.position = self.monkey.position
            
            self.addChild(throwable)
            
            throwable.physicsBody?.velocity = CGVectorMake(0,0)
            throwable.physicsBody?.applyImpulse(CGVectorMake(throwX, throwable.throwForceY()))
        }
    }
    
    private func frenzyThrowable() -> Throwable {
        let diceRoll = Int(arc4random_uniform(100))
        
        let shouldThrowHeart = !lives.isFull() && monkey.canThrowHeart()
        let shouldThrowSupernut = monkey.currentLevel() > 5 && diceRoll < monkey.currentLevel()
        
        if shouldThrowHeart {
            return Heart()
        } else if shouldThrowSupernut {
            return Supernut()
        } else {
            return Coconut()
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
        } else if let supernut = item as? Supernut {
            let numSpawns: Int = monkey.currentLevel() / 5
            
            for _ in 1...numSpawns {
                let spawnPos = CGPointMake(supernut.position.x, ground.size.height + 30)
                let spawn = Coconut.spawnAt(spawnPos)
                let throwX = CGFloat(arc4random_uniform(20)) - 10.0
                let throwY = spawn.throwForceY() + CGFloat(arc4random_uniform(10) + 5)
                
                addChild(spawn)
                spawn.physicsBody?.velocity = CGVectorMake(0,0)
                spawn.physicsBody?.applyImpulse(CGVectorMake(throwX, throwY))
            }

            let brokenutPos = CGPointMake(supernut.position.x, ground.size.height + 5)
            let brokenut = Brokenut(pos: brokenutPos, sizeFactor: 1.5)
            
            addChild(brokenut)
            supernut.removeFromParent()
            
        } else if let heart = item as? Heart {
            let fadeAction = SKAction.fadeOutWithDuration(0.5)
            let removeAction = SKAction.runBlock { heart.removeFromParent() }
            
            heart.runAction(SKAction.sequence([fadeAction, removeAction]))
            
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
