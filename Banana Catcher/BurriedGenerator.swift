import Foundation
import SpriteKit

class BurriedGenerator: Generator {
    
    override func generate() {
        let positions: [CGPoint] = burriedPositions()
        let numBurried = positions.count
        
        for i in 0..<numBurried {
            let burried = SKSpriteNode(imageNamed: "burried_\(burriedIndex()).png")
            
            burried.position = positions[i]
            burried.zPosition = -800
            burried.zRotation = burriedRotation()
            burried.alpha = burriedAlpha()
            scene.addChild(burried)
        }
    }
    
    private func burriedPositions() -> [CGPoint] {
        let x1 = hWidth - 100 - CGFloat(random(30))
        let x2 = hWidth - 20 - CGFloat(random(50))
        let x3 = hWidth + 20 + CGFloat(random(50))
        let x4 = hWidth + 100 + CGFloat(random(30))
        
        let topY = yBaseLevel - 65
        let botY = topY - 45
        
        switch random(8) {
        case 0: return [
                CGPointMake(x1, topY + CGFloat(randomBalanced(40))),
                CGPointMake(x2, botY + CGFloat(randomBalanced(40))),
                CGPointMake(x3, topY + CGFloat(randomBalanced(40))),
                CGPointMake(x4, botY + CGFloat(randomBalanced(40)))
            ]
        case 1: return [
            CGPointMake(x1, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x3, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x4, topY + CGFloat(randomBalanced(40)))
            ]
        case 2: return [
            CGPointMake(x1 + (x2 - x1) / 2, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x2 + (x3 - x2) / 2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x3 + (x4 - x3) / 2, botY + CGFloat(randomBalanced(40)))
            ]
        case 3: return [
            CGPointMake(x1 + (x2 - x1) / 2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x2 + (x3 - x2) / 2, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x3 + (x4 - x3) / 2, topY + CGFloat(randomBalanced(40)))
            ]
        case 4: return [
            CGPointMake(x1 / 2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x1 + (x2 - x1) / 2, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x3 + (x4 - x3) / 2, topY + CGFloat(randomBalanced(40)))
            ]
        case 5: return [
            CGPointMake(x1 / 2, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x1 + (x2 - x1) / 2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x3 + (x4 - x3) / 2, botY + CGFloat(randomBalanced(40)))
            ]
        case 6: return [
            CGPointMake(x1 + (x2 - x1) / 2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x3 + (x4 - x3) / 2, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x4, topY + CGFloat(randomBalanced(40)))
            ]
        default: return [
            CGPointMake(x1 + (x2 - x1) / 2, botY + CGFloat(randomBalanced(40))),
            CGPointMake(x3 + (x4 - x3) / 2, topY + CGFloat(randomBalanced(40))),
            CGPointMake(x4, botY + CGFloat(randomBalanced(40)))
            ]
        }
    }
    
    private func burriedIndex() -> Int {
        let count = DoodadCounts.buried
        
        return Int(arc4random_uniform(count)) + 1
    }
    
    private func burriedAlpha() -> CGFloat {
        let alphas = (6...9).map { CGFloat($0) / 10.0 }
        let i = random(alphas.count)
        
        return alphas[i]
    }
    
    private func burriedRotation() -> CGFloat {
        let rotations = (0...4).map { CGFloat($0) / 5 }
        let i = Int(arc4random_uniform(UInt32(rotations.count)))
        
        return rotations[i]
    }
}
