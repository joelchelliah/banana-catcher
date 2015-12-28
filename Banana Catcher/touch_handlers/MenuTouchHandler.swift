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
                
            default: break
            }
        }
    }
    
    private func toggleSound(button: SKNode, _ menuScene: MenuScene) {
        soundEnabled = !soundEnabled
        
        let texture = soundEnabled ? "sound_on.png" : "sound_off.png"
        let toggleTexture = SKAction.runBlock {
            menuScene.changeSoundButtonTexture(texture)
        }
        
        buttonClick(button, action: toggleTexture)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(soundEnabled, forKey: "soundEnabled")
        defaults.synchronize()
        
        musicPlayer.toggle()
    }
    
    private func gotoTutorial(node: SKNode) {
        buttonClick(node, toScene: TutorialScene(size: scene.size))
    }

    private func gotoNoAds(node: SKNode, _ menuScene: MenuScene) {
        
        let purchase = SKAction.runBlock {
            menuScene.purchaseNoAds()
        }
        
        buttonClick(node, action: purchase)
    }
}
