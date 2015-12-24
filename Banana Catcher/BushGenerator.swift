import Foundation
import SpriteKit

class BushGenerator {

    private var scene: SKScene
    private var height: CGFloat
    private var width: CGFloat
    private var hWidth: CGFloat
    
    private let numBushes = 2
    
    init(withScene: SKScene) {
        scene = withScene
        height = scene.frame.height
        width = scene.frame.width
        hWidth = width / 2
    }
    
    func generate(at groundLevel: CGFloat) {
        let positions: [CGFloat] = bushPositions()
        
        for i in 0..<numBushes {
            let bushPos = positions[i]
            let bush = SKSpriteNode(imageNamed: "bush_\(bushIndex()).png")
            
            bush.position = CGPointMake(bushPos, groundLevel + bush.size.height / 2)
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
