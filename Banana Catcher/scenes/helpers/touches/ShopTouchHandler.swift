import Foundation
import SpriteKit

class ShopTouchHandler: TouchHandler {
    
    override func handle(touches: Set<UITouch>) {
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.purchase: purchaseNoAds(touchedNode)
                
            case ButtonNodes.restore: restoreNoAds(touchedNode)
                
            case ButtonNodes.back: gotoMenu(touchedNode)
                
            case ButtonNodes.basketManMenu: sayHello(touchedNode)
                
            default: break
            }
        }
    }
    
    private func purchaseNoAds(button: SKNode) {
        buttonClick(button) {
            (self.scene as! ShopScene).purchaseNoAds()
        }
    }
    
    private func restoreNoAds(button: SKNode) {
        buttonClick(button) {
            (self.scene as! ShopScene).restoreNoAds()
        }
    }
}
