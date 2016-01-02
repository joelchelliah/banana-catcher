import Foundation
import SpriteKit

class TutorialTouchHandler: TouchHandler {
    
    override func handle(touches: Set<UITouch>) {
        let tutorialScene = scene as! TutorialScene
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
                
            case ButtonNodes.next: playNextTutorialStage(touchedNode, tutorialScene: tutorialScene)
                
            case ButtonNodes.ok: gotoMenu(touchedNode)
                
            default: break
            }
        }
    }
    
    private func playNextTutorialStage(button: SKNode, tutorialScene: TutorialScene) {
        buttonClick(button) {
            tutorialScene.playNextStage()
        }
    }
}
