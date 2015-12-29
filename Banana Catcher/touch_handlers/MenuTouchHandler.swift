import Foundation
import SpriteKit

class MenuTouchHandler: TouchHandler {

    override func handle(touches: Set<UITouch>) {
        let menuScene = scene as! MenuScene
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.sound: toggleSound(touchedNode, menuScene)
                
            case ButtonNodes.howTo: gotoTutorial(touchedNode)
                
            case ButtonNodes.play: gotoGame(touchedNode)
                
            case ButtonNodes.noAds: gotoNoAds(touchedNode, menuScene)
                
            case ButtonNodes.rating: gotoRating(touchedNode)
                
            case ButtonNodes.basketManMenu: sayHello(touchedNode, menuScene)
                
            default: break
            }
        }
    }
    
    private func toggleSound(button: SKNode, _ menuScene: MenuScene) {
        soundEnabled = !soundEnabled
        
        let texture = soundEnabled ? "sound_on.png" : "sound_off.png"
        
        buttonClick(button) {
            menuScene.changeSoundButtonTexture(texture)
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(soundEnabled, forKey: "soundEnabled")
        defaults.synchronize()
        
        musicPlayer.toggle()
    }
    
    private func gotoTutorial(node: SKNode) {
        buttonClick(node, toScene: TutorialScene(size: scene.size))
    }

    private func gotoNoAds(node: SKNode, _ menuScene: MenuScene) {
        buttonClick(node) {
            menuScene.purchaseNoAds()
        }
    }
    
    private func sayHello(node: SKNode, _ menuScene: MenuScene) {
        node.runAction(SKAction.runBlock {
            PlaySound.select(from: node)
            
            menuScene.basketManSaysHello()
            })
    }
}
