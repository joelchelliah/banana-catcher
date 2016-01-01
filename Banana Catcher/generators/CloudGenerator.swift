import Foundation
import SpriteKit

class CloudGenerator: Generator {
    
    private var cloudHeights: [CGFloat]!
    private var zCounter: CGFloat = -800
    
    init(forScene scene: SKScene, fromZPos: CGFloat = -800) {
        super.init(forScene: scene, yBasePos: 0)
        
        cloudHeights = initCloudHeights()
    }
    
    override func generate() {
        let randomDuration = Double(arc4random_uniform(4) + 3)
        
        let wait = SKAction.waitForDuration(randomDuration)
        let makeCloud = SKAction.runBlock {
            self.spawnCloud()
        }
        let regenerate = SKAction.runBlock {
            self.generate()
        }
        
        scene.runAction(SKAction.sequence([makeCloud, wait, regenerate]))
    }
    
    
    private func spawnCloud() {
        let direction = [-1, 1][Int(arc4random_uniform(2))]
        let cIndex = random(DoodadCounts.clouds) + 1
        
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
        let cloudPositionY = cloudHeights[random(cloudHeights.count)]
        
        return CGPointMake(cloudPositionX, cloudPositionY)
    }
    
    private func cloudAlpha() -> CGFloat {
        let alphas = (4...8).map { CGFloat($0) / 10.0 }
        let i = random(alphas.count)
        
        return alphas[i]
    }
    
    private func cloudDuration() -> Double {
        let durations = 8.stride(to: 16, by: 4).map { Double($0) }
        let i = random(durations.count)
        
        return durations[i]
    }
    
    private func initCloudHeights() -> [CGFloat] {
        let min = 75
        let max = 275
        let step = 25
        
        return (min.stride(to: max, by: step)).map { height - CGFloat($0) }
    }
}
