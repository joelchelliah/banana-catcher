import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, CollissionDetector, ThrowSupport {
    
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
        
        Ads.showBanner()
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
        handleContact(contact: contact,
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
            let frenzy = coconutFrenzyActions()
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
            
        case is Coconut, is Banananut, is Heartnut:
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
            
            addChild(splatBanana)
            item.removeFromParent()
            
        case is Coconut, is Banananut, is Heartnut:
            let spawnPos = CGPointMake(item.position.x, ground.size.height + 30)
            
            switch item {
                
            case is Banananut: throwSpawnedItem(Banana.spawnAt(spawnPos))
                
            case is Heartnut: throwSpawnedItem(Heart.spawnAt(spawnPos))
                
            default: break
            }

            addChild(Brokenut(pos: spawnPos))
            item.removeFromParent()
            
        case is Supernut:
            let numSpawns: Int = monkey.currentLevel() / 5
            let spawnPos = CGPointMake(item.position.x, ground.size.height + 30)
            
            for _ in 1...numSpawns {
                throwSpawnedItem(Coconut.spawnAt(spawnPos))
            }

            let broke = Superbroke(pos: spawnPos)
            
            addChild(broke)
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
