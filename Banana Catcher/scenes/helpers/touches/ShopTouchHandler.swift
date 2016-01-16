import Foundation
import SpriteKit

class ShopTouchHandler: TouchHandler {
    
    override func handle(touches: Set<UITouch>) {
        let shopScene = scene as! ShopScene
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.purchase: purchaseNoAds(touchedNode)
                
            case ButtonNodes.restore: restoreNoAds(touchedNode)
                
            case ButtonNodes.back: gotoMenu(<#T##node: SKNode##SKNode#>)
                
            case ButtonNodes.basketManMenu: sayHello(touchedNode, shopScene)
                
            default: break
            }
        }
    }
    
    private func purchaseNoAds(button: SKNode) {
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
    
    private func restoreNoAds(node: SKNode) {
        buttonClick(node, toScene: TutorialScene(size: scene.size))
    }
    
    private func gotoNoAds(node: SKNode, _ menuScene: MenuScene) {
        buttonClick(node) {
            menuScene.purchaseNoAds()
        }
    }
}
