import Foundation
import SpriteKit

class BushGenerator {

    private let scene: SKScene
    private let height: CGFloat
    private let width: CGFloat
    private let hWidth: CGFloat
    private let yBaseLevel: CGFloat
    
    private let numBushes = 2
    
    init(withScene: SKScene, yBasePos: CGFloat) {
        scene = withScene
        height = scene.frame.height
        width = scene.frame.width
        hWidth = width / 2
        yBaseLevel = yBasePos
    }
    
    convenience init(withScene: SKScene) {
        self.init(withScene: withScene, yBasePos: 0)
    }
    
    func generate() {
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
