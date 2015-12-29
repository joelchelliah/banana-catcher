import Foundation
import SpriteKit
import GameKit

class GameOverTouchHandler: TouchHandler {
    
    private var gameCenterEnabled = false
    private var gameCenterDefaultLeaderBoard = ""
    
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
        buttonClick(node) {
            self.presentGameCenterLeaderboard()
        }
    }
    
    private func presentGameCenterLeaderboard() {
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        
        gcViewController.gameCenterDelegate = scene as? GKGameCenterControllerDelegate
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gcViewController.leaderboardIdentifier = leaderboardID
        
        rootViewController().presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    private func gotoSharing(node: SKNode) {
        let message1 = "🍌 Yeah! 🍌"
        let message2 = "\r\nJust got \(score) points in Banana Catcher!"
        let activityViewController = UIActivityViewController(activityItems: [message1, message2], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.excludedActivityTypes = sharingExclusionList()
        
        buttonClick(node) {
            self.rootViewController().presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func sharingExclusionList() -> [String] {
        let exclude = [
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypeAirDrop,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeSaveToCameraRoll
        ]
        
        if #available(iOS 9.0, *) {
            return exclude + [UIActivityTypeOpenInIBooks]
        } else {
            return exclude
        }
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Misc
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func rootViewController() -> UIViewController {
        return (scene.view?.window?.rootViewController)!
    }
}
