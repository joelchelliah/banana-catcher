import SpriteKit

class TutorialScene: SKScene, SKPhysicsContactDelegate, CollissionDetector {
    
    private var hWidth: CGFloat = 0.0

    private let ground: Ground = Ground()
    private let basketMan: BasketMan = BasketMan()
    private let monkey: EvilMonkey = EvilMonkey()
    
    private var touchHandler: TouchHandler!
    private var helper: TutorialStageHelper!
    
    private var nextButton: SKSpriteNode!
    private var infoLabel:  InfoLabel!
    
    override func didMoveToView(view: SKView) {
        hWidth = size.width / 2
        touchHandler = TutorialTouchHandler(forScene: self)
        
        musicPlayer.change("tutorial")

        adjustPhysics()
        addBackgroundImage()
        addGround()
        addDoodads()
        addBasketMan()
        addEvilMonkey()
        addDarkness()
        addLabels()
        addButtons()
        addStageHelper()
        
        Ads.hideBanner()
    }
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler.handle(touches)
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
    
    private func adjustPhysics() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
    }
    
    private func addBackgroundImage() {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPointMake(CGRectGetMidX(frame), background.size.height / 2)
        background.zPosition = -999
        addChild(background)
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
        monkey.position = CGPoint(x: hWidth, y: size.height - 180)
        
        addChild(monkey)
    }
    
    private func addDarkness() {
        let topDarkness = SKSpriteNode(imageNamed: "darkness_top.png")
        let bottomDarkness = SKSpriteNode(imageNamed: "darkness_bottom.png")
        
        topDarkness.size.height *= 0.5
        bottomDarkness.size.height *= 0.7
        
        topDarkness.position = CGPointMake(hWidth, size.height - topDarkness.size.height / 2)
        bottomDarkness.position = CGPointMake(hWidth, bottomDarkness.size.height / 2 - 50)
        
        [topDarkness, bottomDarkness].forEach {
            $0.zPosition = -600
            addChild($0)
        }
    }
    
    private func addLabels() {
        let zPos: CGFloat = -500
        let header = TutorialLabel(x: hWidth, y: size.height - 45, zPosition: zPos)
        
        infoLabel = InfoLabel(x: hWidth, y: size.height - 100, zPosition: zPos)
        
        addChild(header)
        addChild(infoLabel)
    }
    
    private func addButtons() {
        let buttonGenerator = ButtonGenerator(forScene: self, yBasePos: 40)
        
        buttonGenerator.generate()
        
        nextButton = buttonGenerator.nextButton
    }
    
    private func addStageHelper() {
        helper = TutorialStageHelper(scene: self)
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Tutorial stages
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    func playNextStage() {
        helper.playNextStage()
    }
    
    func prepareForNextStage(isLastStage: Bool) {
        infoLabel.clear()
        nextButton.alpha = 0.2
        
        if isLastStage {
            nextButton.name = ButtonNodes.ok
            nextButton.texture = SKTexture(imageNamed: "ok.png")
        }
    }
    
    func enableNextButton() {
        nextButton.alpha = 1.0
    }
    
    func changeInfoLabelText(text: String)  {
        self.infoLabel.changeText(text)
    }
    
    func basketManMoves(x: CGFloat) {
        let destination = hWidth + x
        let distance = abs(basketMan.position.x - destination)
        let duration = NSTimeInterval(distance / 200)
        
        let wait = SKAction.waitForDuration(0.4)
        let move = SKAction.moveToX(destination, duration: duration)
        
        basketMan.runAction(SKAction.sequence([wait, move]))
    }
    
    func monkeyThrows(item: Throwable, throwForceX: CGFloat) {
        item.position = CGPoint(x: monkey.position.x, y: monkey.position.y)
        
        addChild(item)
        
        item.physicsBody?.velocity = CGVectorMake(0,0)
        item.physicsBody?.applyImpulse(CGVectorMake(throwForceX, item.throwForceY()))
        
        monkey.bounce()
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Collission detection callbacks
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func throwableHitsBasketMan(item: Throwable) {
        switch item {
            
        case is Banana:
            let pos = item.position
            let label = CollectPointLabel(points: GamePoints.BananaCaught, x: pos.x, y: pos.y)
            
            addChild(label)
            basketMan.collect()
            
        case is Coconut:
            basketMan.ouch()
            
        default:
            unexpectedHit(item, receiver: "BasketMan")
        }
        
        item.removeFromParent()
    }
    
    private func throwableHitsGround(item: Throwable) {
        switch item {
            
        case is Banana:
            basketMan.frown()

            item.removeFromParent()
            
        case is Coconut:
            let pos = CGPointMake(item.position.x, ground.size.height + 5)
            let brokenut = Brokenut(pos: pos)
            
            addChild(brokenut)
            
        default:
            unexpectedHit(item, receiver: "the ground")
        }
        
        item.removeFromParent()
    }
    
    private func unexpectedHit(item: Throwable, receiver: String) {
        fatalError("Unexpected item (\(item)) hit \(receiver)!")
    }
}
