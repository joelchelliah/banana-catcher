import Foundation
import SpriteKit

class CloudGenerator {
    
    private var scene: SKScene
    private var height: CGFloat
    private var width: CGFloat
    private var cloudHeights: [CGFloat] = []
    private var zCounter: CGFloat = -800
    
    init(withScene: SKScene) {
        scene = withScene
        height = scene.frame.height
        width = scene.frame.width
        
        cloudHeights = (75.stride(to: 275, by: 50)).map { height - CGFloat($0) }
    }
    
    func generate() {
        let randomDuration = Double(arc4random_uniform(4) + 2)
        
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
        
        cloud.position = cloudPosition(direction, leftLimit: cLeftLimit, rightLimit: cRightLimit)
        cloud.alpha = cloudAlpha()
        cloud.zPosition = zCounter
        
        zCounter -= 1
        scene.addChild(cloud)
        
        let move = SKAction.moveToX(direction < 0 ? cLeftLimit : cRightLimit, duration: cloudDuration())
        let destroy = SKAction.runBlock { cloud.removeFromParent() }
        
        cloud.runAction(SKAction.sequence([move, destroy]))
    }
    
    private func cloudPosition(direction: Int, leftLimit: CGFloat, rightLimit: CGFloat) -> CGPoint {
        let cloudPositionX = direction < 0 ? rightLimit : leftLimit
        let cloudPositionY = cloudHeights[Int(arc4random_uniform(UInt32(cloudHeights.count)))]
        
        return CGPointMake(cloudPositionX, cloudPositionY)
    }
    
    private func cloudAlpha() -> CGFloat {
        let alphas = (4...8).map { CGFloat($0) / 10.0 }
        let i = Int(arc4random_uniform(UInt32(alphas.count)))
        
        return alphas[i]
    }
    
    private func cloudDuration() -> Double {
        let durations = 8.stride(to: 16, by: 4).map { Double($0) }
        let i = Int(arc4random_uniform(UInt32(durations.count)))
        
        return durations[i]
    }
}
