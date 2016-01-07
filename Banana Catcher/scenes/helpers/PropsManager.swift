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
    internal var levelUpLabel: LevelUpLabel!
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
    
    internal func screenHeightOffset() -> CGFloat {
        switch height {
        
        case 0..<500: return 0
            
        case 500..<650: return 45
            
        case 650..<700: return 90
            
        case 700..<750: return 150
            
        case 750..<800: return 200
            
        default: return 250
        }
    }
}
