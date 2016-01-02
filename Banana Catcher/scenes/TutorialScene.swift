import SpriteKit

class TutorialScene: SKScene, SKPhysicsContactDelegate, CollissionDetector {
    
    private var touchHandler: TouchHandler!
    
    private var props: PropsManager!
    private var basketMan: BasketMan!
    private var monkey: EvilMonkey!
    private var infoLabel:  InfoLabel!
    private var nextButton: SKSpriteNode!

    private var helper: TutorialStageHelper!
    
    override func didMoveToView(view: SKView) {
        initPhysics()
        
        touchHandler = TutorialTouchHandler(forScene: self)
        
        props = TutorialProps.init(forScene: self)
        props.add()
        
        basketMan = props.basketMan
        monkey = props.monkey
        infoLabel = props.infoLabel
        nextButton = props.nextButton
        
        helper = TutorialStageHelper(scene: self)
        
        musicPlayer.change("tutorial")

        Ads.hideBanner()
    }
    
    private func initPhysics() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
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
        let destination = CGRectGetMidX(frame) + x
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
            let pos = CGPointMake(item.position.x, props.groundLevel + 5)
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
