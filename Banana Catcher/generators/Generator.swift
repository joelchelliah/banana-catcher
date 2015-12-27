import Foundation
import SpriteKit

class Generator {
    internal let scene: SKScene
    internal let height: CGFloat
    internal let width: CGFloat
    internal let hWidth: CGFloat
    internal let yBaseLevel: CGFloat
    
    init(forScene: SKScene, yBasePos: CGFloat) {
        scene = forScene
        height = scene.frame.height
        width = scene.frame.width
        hWidth = width / 2
        yBaseLevel = yBasePos
    }
    
    func generate() {
        fatalError("generate() function has not been overridden!")
    }
    
    internal func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    internal func randomBalanced(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n))) - n / 2
    }
}
