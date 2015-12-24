import Foundation
import SpriteKit

class CloudGenerator {
    
    private var scene: SKScene
    private var height: CGFloat
    private var width: CGFloat
    private var cloudHeights: [CGFloat] = []
    private var zCounter: CGFloat = -500
    
    init(withScene: SKScene) {
        scene = withScene
        height = scene.frame.height
        width = scene.frame.width
        
        cloudHeights = (75.stride(to: 225, by: 25)).map { height - CGFloat($0) }
    }
    
    func generate() {
        let randomDuration = Double(arc4random_uniform(4) + 5)
        
        let wait = SKAction.waitForDuration(randomDuration)
        let makeCloud = SKAction.runBlock {
            self.spawnCloud()
        }
        let regenerate = SKAction.runBlock {
            self.generate()
        }
        
        scene.runAction(SKAction.sequence([makeCloud, wait, regenerate]))
    }
    
    
    internal func spawnCloud() {
        let direction = [-1, 1][Int(arc4random_uniform(2))]
        let cIndex = Int(arc4random_uniform(DoodadCounts.clouds)) + 1
        
        let cloud = SKSpriteNode(imageNamed: "cloud_\(cIndex)")
        
        let cHalfWidth = cloud.size.width / 2
        let cLeftLimit = -cHalfWidth
        let cRightLimit = width + cHalfWidth
        
        let cloudPositionX = direction < 0 ? cRightLimit : cLeftLimit
        let cloudPositionY = cloudHeights[Int(arc4random_uniform(UInt32(cloudHeights.count)))]
        
        cloud.position = CGPointMake(cloudPositionX, cloudPositionY)
        cloud.zPosition = zCounter
        zCounter -= 1
        
        scene.addChild(cloud)
        
        let move = SKAction.moveToX(direction < 0 ? cLeftLimit : cRightLimit, duration: 15)
        let destroy = SKAction.runBlock { cloud.removeFromParent() }
        
        cloud.runAction(SKAction.sequence([move, destroy]))
    }
}
