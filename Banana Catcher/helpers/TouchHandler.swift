import Foundation
import SpriteKit

class TouchHandler {
    
    private let scene: SKScene
    
    init(forScene scene: SKScene) {
        self.scene = scene
    }

    func handle(touches: Set<UITouch>) {
        switch scene {
            
        case is MenuScene: handleForMenuScene(touches)
            
        case is TutorialScene: handleForTutorialScene(touches)
            
        case is GameOverScene: handleForGameOverScene(touches)
            
        default: fatalError("Unexpected scene: \(scene)!")
        }
    }
    
    private func handleForMenuScene(touches: Set<UITouch>) {
        let menuScene = scene as! MenuScene
        let touchLocation = touches.first!.locationInNode(scene)
        let touchedNode = scene.nodeAtPoint(touchLocation)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.sound: toggleSound(touchedNode, menuScene: menuScene)
                
            case ButtonNodes.howTo: gotoTutorial(touchedNode)
                
            case ButtonNodes.play: gotoGame(touchedNode)
                
            case ButtonNodes.noAds: gotoNoAds(touchedNode)
                
            case ButtonNodes.rating: gotoRating(touchedNode)
                
            default: break
            }
        }
    }
    
    private func handleForTutorialScene(touches: Set<UITouch>) {
        let tutorialScene = scene as! TutorialScene
        let touchLocation = touches.first!.locationInNode(scene)
        let touchedNode = scene.nodeAtPoint(touchLocation)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.next: playNextTutorialStage(touchedNode, tutorialScene: tutorialScene)
                
            default: break
            }
        }
    }
    
    private func handleForGameOverScene(touches: Set<UITouch>) {
        
    }
    
    private func toggleSound(button: SKNode, menuScene scene: MenuScene) {
        soundEnabled = !soundEnabled
        
        let texture = soundEnabled ? "sound_on.png" : "sound_off.png"
        let toggleTexture = SKAction.runBlock {
            scene.soundButton.texture = SKTexture(imageNamed: texture)
        }
        
        buttonClick(button, action: toggleTexture)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(soundEnabled, forKey: "soundEnabled")
        defaults.synchronize()
        
        musicPlayer.toggle()
    }
    
    private func gotoTutorial(node: SKNode) {
        let tutorialScene = TutorialScene(size: scene.size)
        
        buttonClick(node, toScene: tutorialScene)
    }
    
    private func gotoGame(node: SKNode) {
        let gameScene = GameScene(size: scene.size)
        
        buttonClick(node, toScene: gameScene)
    }
    
    private func gotoNoAds(node: SKNode) {
        
    }
    
    private func gotoRating(node: SKNode) {
        let appUrl = NSURL(string : "http://itunes.com/app/id1070905846")!
        
        buttonClick(node, forUrl: appUrl)
    }
    
    private func playNextTutorialStage(button: SKNode, tutorialScene: TutorialScene) {
        let nextStage = SKAction.runBlock {
            tutorialScene.helper.playNextStage()
        }
        
        buttonClick(button, action: nextStage)
    }
    
    private func buttonClick(button: SKNode, toScene: SKScene) {
        let presentScene = SKAction.runBlock {
            toScene.scaleMode = self.scene.scaleMode
            self.scene.view?.presentScene(toScene, transition: SKTransition.flipVerticalWithDuration(0.5))
        }
        
        buttonClick(button, action: presentScene)
    }
    
    private func buttonClick(button: SKNode, forUrl url: NSURL) {
        let presentScene = SKAction.runBlock {
            UIApplication.sharedApplication().openURL(url);
        }
        
        buttonClick(button, action: presentScene)
    }
    
    private func buttonClick(button: SKNode, action: SKAction) {
        let fadeOut = SKAction.fadeAlphaTo(0.2, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { PlaySound.select(from: self.scene) }

        button.runAction(SKAction.sequence([fadeOut, sound, fadeIn, action]))
    }
}
