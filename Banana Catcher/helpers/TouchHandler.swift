import Foundation
import SpriteKit
import GameKit

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
        let touchedNode = getTouchedNode(touches)

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
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.next:
                playNextTutorialStage(touchedNode, tutorialScene: tutorialScene)
                
            default: break
            }
        }
    }
    
    private func handleForGameOverScene(touches: Set<UITouch>) {
        let touchedNode = getTouchedNode(touches)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case ButtonNodes.home: gotoMenu(touchedNode)
                
            case ButtonNodes.highscore: gotoLeaderboard(touchedNode)
                
            case ButtonNodes.retry: gotoGame(touchedNode)
                
            case ButtonNodes.share: gotoSharing(touchedNode)
                
            case ButtonNodes.rating: gotoRating(touchedNode)
                
            default: break
            }
        }
    }
    
    private func getTouchedNode(touches: Set<UITouch>) -> SKNode {
        let touchLocation = touches.first!.locationInNode(scene)
        
        return scene.nodeAtPoint(touchLocation)
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
    
    private func gotoMenu(node: SKNode) {
        buttonClick(node, toScene: MenuScene(size: scene.size))
    }
    
    private func gotoTutorial(node: SKNode) {
        buttonClick(node, toScene: TutorialScene(size: scene.size))
    }
    
    private func gotoGame(node: SKNode) {
        buttonClick(node, toScene: GameScene(size: scene.size))
    }
    
    private func gotoLeaderboard(node: SKNode) {
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        
        gcViewController.gameCenterDelegate = scene as? GKGameCenterControllerDelegate
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gcViewController.leaderboardIdentifier = leaderboardID
        
        let presentViewController = SKAction.runBlock {
            self.rootViewController().presentViewController(gcViewController, animated: true, completion: nil)
        }
        
        buttonClick(node, action: presentViewController)
    }
    
    private func gotoNoAds(node: SKNode) {
        
    }
    
    private func gotoSharing(node: SKNode) {
        let message1 = "🍌 Yeah! 🍌"
        let message2 = "\r\nJust got \(score) points in Banana Catcher!"
        
        let activityViewController = UIActivityViewController(activityItems: [message1, message2], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        let exclude = [
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypeAirDrop,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeSaveToCameraRoll
        ]
        
        if #available(iOS 9.0, *) {
            activityViewController.excludedActivityTypes = exclude + [UIActivityTypeOpenInIBooks]
        } else {
            activityViewController.excludedActivityTypes = exclude
        }
        
        let presentViewController = SKAction.runBlock {
            self.rootViewController().presentViewController(activityViewController, animated: true, completion: nil)
        }
        
        buttonClick(node, action: presentViewController)
    }
    
    private func gotoRating(node: SKNode) {
        let appUrl = NSURL(string : "http://itunes.com/app/id1070905846")!
        
        buttonClick(node, forUrl: appUrl)
    }
    
    private func playNextTutorialStage(button: SKNode, tutorialScene: TutorialScene) {
        PlaySound.select(from: self.scene)
        
        tutorialScene.playNextStage()
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
    
    private func rootViewController() -> UIViewController {
        return (scene.view?.window?.rootViewController)!
    }
}
