import Foundation
import SpriteKit

class TutorialTouchHandler: TouchHandler {
    
    override func handle(touches: Set<UITouch>) {
        let tutorialScene = scene as! TutorialScene
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
                
            case ButtonNodes.next: playNextTutorialStage(touchedNode, tutorialScene: tutorialScene)
                
            case ButtonNodes.ok: endTutorial(touchedNode)
                
            default: break
            }
        }
    }
    
    private func playNextTutorialStage(button: SKNode, tutorialScene: TutorialScene) {
        if button.alpha == 1 {
            buttonClick(button) {
                tutorialScene.playNextStage()
            }
        }
    }
    
    private func endTutorial(button: SKNode) {
        if button.alpha == 1 {
            gotoMenu(button)
        }
    }
}
