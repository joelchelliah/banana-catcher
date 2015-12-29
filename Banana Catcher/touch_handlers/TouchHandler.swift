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
        toScene.scaleMode = scene.scaleMode

        buttonClick(button) {
            self.scene.view?.presentScene(toScene, transition: SKTransition.flipVerticalWithDuration(0.5))
        }
    }
    
    internal func buttonClick(button: SKNode, forUrl url: NSURL) {
        buttonClick(button) {
            UIApplication.sharedApplication().openURL(url);
        }
    }
    
    internal func buttonClick(button: SKNode, block: dispatch_block_t) {
        let sound = SKAction.runBlock { PlaySound.select(from: self.scene) }
        let action = SKAction.runBlock(block)
        
        if let size = (button as? SKSpriteNode)?.texture?.size() {
            let grow = SKAction.resizeToWidth(size.width * 1.5, height: size.height * 1.5, duration: 0.1)
            let shrink = SKAction.resizeToWidth(size.width, height: size.height, duration: 0.1)
            
            button.runAction(SKAction.sequence([grow, sound, shrink, action]))
        } else {
            button.runAction(SKAction.sequence([sound, action]))
        }
    }
}
