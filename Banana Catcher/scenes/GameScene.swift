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
        
        BannerAds.show()
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
        CollissionDetector.run(
            contact: contact,
            onHitBasketMan: throwableHitsBasketMan,
            onHitGround: throwableHitsGround)
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
        let groundLevel = ground.size.height
        let cloudGen = CloudGenerator(forScene: self)
        let bushGen = BushGenerator(forScene: self, yBasePos: groundLevel)
        let burriedGen = BurriedGenerator(forScene: self, yBasePos: groundLevel)
        
        [burriedGen, bushGen, cloudGen].forEach { $0.generate() }
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
    
    private func updateScore(points: Int) {
        score += points
        scoreLabel.setScore(score)
    }
    
    private func updateMonkey() {
        let levelBefore = monkey.currentLevel()
        monkey.enrage()
        let currentLevel = monkey.currentLevel()
        
        if currentLevel > levelBefore {
            if currentLevel == 5 { musicPlayer.change("game_2") }
            if currentLevel == 10 { musicPlayer.change("game_3") }
            if currentLevel == 15 { musicPlayer.change("game_4") }
            if currentLevel == 20 { musicPlayer.change("game_5") }
            
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
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Collission detection callbacks
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func throwableHitsBasketMan(item: Throwable) {
        let pos = item.position
        
        switch item {
        case is Banana:
            let points = GamePoints.BananaCaught
            
            showCollectPoints(pos, points)
            updateScore(points)
            basketMan.collect()
            updateMonkey()
            
        case is Coconut:
            coconutHitsBasketMan(pos, GamePoints.CoconutCaught)

        case is Supernut:
            coconutHitsBasketMan(pos, GamePoints.SupernutCaught)
            
        case is Heart:
            let points = GamePoints.HeartCaught
            
            showCollectPoints(pos, points)
            updateScore(points)
            basketMan.lifeUp()
            incrementLives()
            
        default:
            unexpectedHit(item, receiver: "BasketMan")
        }
        
        item.removeFromParent()
    }
    
    private func coconutHitsBasketMan(pos: CGPoint, _ points: Int) {
        if basketMan.isInvincible() { return }
        
        showCollectPoints(pos, points)
        updateScore(points)
        basketMan.ouch()
        decrementLives()
    }
    
    private func throwableHitsGround(item: Throwable) {
        let pos = item.position
        
        switch item {
        case is Banana:
            let splatBanana = SplatBanana(pos: CGPointMake(item.position.x, ground.size.height + 5))
            let points = GamePoints.BananaMissed
            
            showCollectPoints(CGPointMake(pos.x, pos.y + 15), points)
            updateScore(points)
            basketMan.frown()
            decrementLives()
            
            addChild(splatBanana)
            item.removeFromParent()
            
        case is Coconut:
            let brokenut = Brokenut(pos: CGPointMake(item.position.x, ground.size.height + 5))
            
            addChild(brokenut)
            item.removeFromParent()
            
        case is Supernut:
            let numSpawns: Int = monkey.currentLevel() / 5
            
            for _ in 1...numSpawns {
                let spawnPos = CGPointMake(item.position.x, ground.size.height + 30)
                let spawn = Coconut.spawnAt(spawnPos)
                let throwX = CGFloat(arc4random_uniform(20)) - 10.0
                let throwY = spawn.throwForceY() + CGFloat(arc4random_uniform(10) + 5)
                
                addChild(spawn)
                spawn.physicsBody?.velocity = CGVectorMake(0,0)
                spawn.physicsBody?.applyImpulse(CGVectorMake(throwX, throwY))
            }

            let brokenutPos = CGPointMake(item.position.x, ground.size.height + 5)
            let brokenut = Brokenut(pos: brokenutPos, sizeFactor: 1.5)
            
            addChild(brokenut)
            item.removeFromParent()
            
        case is Heart:
            let fadeOut = SKAction.fadeOutWithDuration(1.0)
            let remove = SKAction.runBlock { item.removeFromParent() }
            
            item.runAction(SKAction.sequence([fadeOut, remove]))
            
        default:
            unexpectedHit(item, receiver: "the ground")
        }
    }

    private func showCollectPoints(pos: CGPoint, _ points: Int) {
        let label = CollectPointLabel(points: points, x: pos.x, y: pos.y)
        
        addChild(label)
    }
    
    private func unexpectedHit(item: Throwable, receiver: String) {
        fatalError("Unexpected item (\(item)) hit \(receiver)!")
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
}
