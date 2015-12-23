import SpriteKit

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    
    private var hWidth: CGFloat = 0.0
    
    private let ground: Ground = Ground()
    private let basketMan: BasketMan = BasketMan()
    private let monkey: EvilMonkey = EvilMonkey()
    
    private let backNode = "prevStage"
    private let nextNode = "nextStage"
    private var currentStage = 1
    
    override func didMoveToView(view: SKView) {
        musicPlayer.change("game_1")
        
        backgroundColor = bgColor
        hWidth = size.width / 2
        
        adjustPhysics()
        addBackgroundImage()
        addGround()
        addBasketMan()
        addEvilMonkey()
    }
        
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == backNode) {
            currentStage -= 1
            
            playSound(self, name: "option_select.wav")
            playCurrentStage()
        } else if(touchedNode.name == nextNode) {
            currentStage += 1
            
            playSound(self, name: "option_select.wav")
            playCurrentStage()
        }
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
    
    private func addBasketMan() {
        basketMan.position = CGPoint(x: hWidth, y: ground.size.height + 10)
        addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        monkey.position = CGPoint(x: hWidth, y: frame.height - 130)
        addChild(monkey)
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Tutorial stages
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func playCurrentStage() {
        
    }
}