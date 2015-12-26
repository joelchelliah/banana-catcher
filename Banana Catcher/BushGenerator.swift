import Foundation
import SpriteKit

class BushGenerator: Generator {
    
    private let numBushes = 2
    
    override func generate() {
        let positions: [CGFloat] = bushXPositions()
        
        for i in 0..<numBushes {
            let baseHeight = yBaseLevel + 15
            let bushXPos = positions[i]
            let bush = SKSpriteNode(imageNamed: "bush_\(bushIndex()).png")
            
            bush.position = CGPointMake(bushXPos, baseHeight + bush.size.height / 2)
            bush.zPosition = -800
            
            scene.addChild(bush)
        }
    }
    
    private func bushXPositions() -> [CGFloat] {
        return [
            hWidth - 50 - CGFloat(random((60))),
            hWidth + 50 + CGFloat(random(60))
        ]
    }
    
    private func bushIndex() -> Int {
        let count = DoodadCounts.bushes
        
        return Int(arc4random_uniform(count)) + 1
    }
}
