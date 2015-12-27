import Foundation
import SpriteKit
import GameKit

class TouchHandler {
    
    internal let scene: SKScene
    
    init(forScene scene: SKScene) {
        self.scene = scene
    }

    func handle(_: Set<UITouch>) {
        fatalError("Unexpected scene: \(scene)!")
    }
    
    internal func getTouchedNode(touches: Set<UITouch>) -> SKNode {
        let touchLocation = touches.first!.locationInNode(scene)
        
        return scene.nodeAtPoint(touchLocation)
    }
    
    internal func gotoMenu(node: SKNode) {
        buttonClick(node, toScene: MenuScene(size: scene.size))
    }
    
    internal func gotoGame(node: SKNode) {
        buttonClick(node, toScene: GameScene(size: scene.size))
    }
    
    internal func gotoRating(node: SKNode) {
        let appUrl = NSURL(string : "http://itunes.com/app/id1070905846")!
        
        buttonClick(node, forUrl: appUrl)
    }
    
    internal func buttonClick(button: SKNode, toScene: SKScene) {
        let presentScene = SKAction.runBlock {
            toScene.scaleMode = self.scene.scaleMode
            self.scene.view?.presentScene(toScene, transition: SKTransition.flipVerticalWithDuration(0.5))
        }
        
        buttonClick(button, action: presentScene)
    }
    
    internal func buttonClick(button: SKNode, forUrl url: NSURL) {
        let presentScene = SKAction.runBlock {
            UIApplication.sharedApplication().openURL(url);
        }
        
        buttonClick(button, action: presentScene)
    }
    
    internal func buttonClick(button: SKNode, action: SKAction) {
        let fadeOut = SKAction.fadeAlphaTo(0.2, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { PlaySound.select(from: self.scene) }

        button.runAction(SKAction.sequence([fadeOut, sound, fadeIn, action]))
    }
}
