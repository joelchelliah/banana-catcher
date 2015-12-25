import Foundation
import SpriteKit

class BushGenerator: Generator {
    
    private let numBushes = 2
    
    override init(forScene scene: SKScene, yBasePos: CGFloat) {
        super.init(forScene: scene, yBasePos: yBasePos)
    }
    
    override func generate() {
        let positions: [CGFloat] = bushPositions()
        
        for i in 0..<numBushes {
            let bushPos = positions[i]
            let bush = SKSpriteNode(imageNamed: "bush_\(bushIndex()).png")
            
            bush.position = CGPointMake(bushPos, yBaseLevel + bush.size.height / 2)
            bush.zPosition = -800
            
            scene.addChild(bush)
        }
    }
    
    private func bushPositions() -> [CGFloat] {
        return [
            hWidth - 50 - CGFloat(arc4random_uniform(60)),
            hWidth + 50 + CGFloat(arc4random_uniform(60))
        ]
    }
    
    private func bushIndex() -> Int {
        let count = DoodadCounts.bushes
        
        return Int(arc4random_uniform(count)) + 1
    }
}
