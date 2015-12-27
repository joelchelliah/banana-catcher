import Foundation
import SpriteKit

struct PlaySound {
    
    static func select(from node: SKNode) {
        play(from: node, name: "option_select.wav")
    }
    
    private static func play(from node: SKNode, name: String) {
        if soundEnabled {
            node.runAction(SKAction.playSoundFileNamed(name, waitForCompletion: false))
        }
    }
}
