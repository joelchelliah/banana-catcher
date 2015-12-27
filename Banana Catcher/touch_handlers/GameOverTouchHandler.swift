import Foundation
import SpriteKit
import GameKit

class GameOverTouchHandler: TouchHandler {
    
    override func handle(touches: Set<UITouch>) {
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
    
    private func rootViewController() -> UIViewController {
        return (scene.view?.window?.rootViewController)!
    }
}
