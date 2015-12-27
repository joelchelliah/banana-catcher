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
        
        let yTop1 = topY + CGFloat(randomBalanced(40))
        let yTop2 = topY + CGFloat(randomBalanced(40))
        let yBot1 = botY + CGFloat(randomBalanced(40))
        let yBot2 = botY + CGFloat(randomBalanced(40))
        
        switch random(12) {
        case 0: return [
                CGPointMake(x1, yTop1),
                CGPointMake(x2, yBot1),
                CGPointMake(x3, yTop2),
                CGPointMake(x4, yBot2)
            ]
        case 1: return [
            CGPointMake(x1, yBot1),
            CGPointMake(x2, yTop1),
            CGPointMake(x3, yBot2),
            CGPointMake(x4, yTop2)
            ]
        case 2: return [
            CGPointMake(x1 + (x2 - x1) / 2, yBot1),
            CGPointMake(x2 + (x3 - x2) / 2, yTop1),
            CGPointMake(x3 + (x4 - x3) / 2, yBot2)
            ]
        case 3: return [
            CGPointMake(x1 + (x2 - x1) / 2, yTop1),
            CGPointMake(x2 + (x3 - x2) / 2, yBot1),
            CGPointMake(x3 + (x4 - x3) / 2, yTop2)
            ]
        case 4: return [
            CGPointMake(x1 / 2, yTop1),
            CGPointMake(x1 + (x2 - x1) / 2, yBot1),
            CGPointMake(x3 + (x4 - x3) / 2, yTop2)
            ]
        case 5: return [
            CGPointMake(x1 / 2, yBot1),
            CGPointMake(x1 + (x2 - x1) / 2, yTop1),
            CGPointMake(x3 + (x4 - x3) / 2, yBot2)
            ]
        case 6: return [
            CGPointMake(x1 + (x2 - x1) / 2, yTop1),
            CGPointMake(x3 + (x4 - x3) / 2, yBot1),
            CGPointMake(x4, yTop2)
            ]
        case 8: return [
            CGPointMake(x1, yTop1),
            CGPointMake(x3, yTop2),
            CGPointMake(x4, yBot1),
            ]
        case 9: return [
            CGPointMake(x1, yBot1),
            CGPointMake(x3, yBot2),
            CGPointMake(x4, yTop1),
            ]
        case 10: return [
            CGPointMake(x1, yTop1),
            CGPointMake(x2, yTop2),
            CGPointMake(x4, yBot1),
            ]
        case 11: return [
            CGPointMake(x1, yBot1),
            CGPointMake(x2, yBot2),
            CGPointMake(x4, yTop1),
            ]
        default: return [ // case 7
            CGPointMake(x1 + (x2 - x1) / 2, yBot1),
            CGPointMake(x3 + (x4 - x3) / 2, yTop1),
            CGPointMake(x4, yBot2)
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
