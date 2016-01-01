import Foundation
import SpriteKit

class PropsManager {
    
    internal let scene: SKScene
    internal let height: CGFloat
    internal let width: CGFloat
    internal let hWidth: CGFloat
    
    internal var groundLevel: CGFloat!
    internal var basketManMenu: BasketManMenu!
    internal var basketMan: BasketMan!
    internal var monkey: EvilMonkey!
    internal var lives: Lives!
    internal var scoreLabel: ScoreLabel!
    internal var infoLabel:  InfoLabel!
    internal var soundButton: SKSpriteNode!
    internal var noAdsButton: SKSpriteNode!
    internal var nextButton: SKSpriteNode!
    
    private var zPos: CGFloat = -999
    
    init(forScene: SKScene) {
        scene = forScene
        height = scene.frame.height
        width = scene.frame.width
        hWidth = width / 2
        
        initPhysics()
    }
    
    func add() {
        fatalError("Missing implementation!")
    }
    
    internal func nextZ() -> CGFloat {
        zPos += 1
        
        return zPos
    }
    
    internal func advanceZBy(num: CGFloat) {
        zPos += num
    }
    
    internal func texturesFor(name name: String, numFrames: Int) -> [SKTexture] {
        return (1...numFrames).map { SKTexture(imageNamed: "\(name)_\($0).png") }
    }
    
    private func initPhysics() {
        switch scene {
        case let scene where scene is SKPhysicsContactDelegate:
            scene.physicsWorld.contactDelegate = scene as? SKPhysicsContactDelegate
            scene.physicsWorld.gravity = CGVectorMake(0, -5)
            
            scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: scene.frame)
            scene.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
            
        default: break
        }
    }
}
