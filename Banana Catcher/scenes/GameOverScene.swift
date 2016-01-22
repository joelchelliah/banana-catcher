import UIKit
import SpriteKit
import GameKit

class GameOverScene: SKScene, GKGameCenterControllerDelegate, SpeechBubble  {
    
    private var touchHandler: TouchHandler!
    private var props: PropsManager!
    
    override func didMoveToView(view: SKView) {
        touchHandler = GameOverTouchHandler(forScene: self)
        
        updateHighScore()
        
        props = GameOverProps.init(forScene: self)
        props.add()
        
        musicPlayer.change("game_over")
        
        Ads.showInterstitial()
        Ads.showBanner()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler.handle(touches)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Score and leaderboard
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func updateHighScore() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
        highScore = defaults.valueForKey("highScore")?.integerValue ?? 0
        defaults.synchronize()
    
        if score > highScore {
            highScore = score
            defaults.setObject(highScore, forKey: "highScore")
            defaults.synchronize()
        }
        
        submitScoreToLeaderboard()
    }
    
    private func submitScoreToLeaderboard() {
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        
        sScore.value = Int64(score)
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            }
        })
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Speech bubble
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var speechBubble = SKSpriteNode()
    
    func setSpeechBubble(bubble: SKSpriteNode) {
        speechBubble.removeFromParent()
        speechBubble = bubble
        speechBubble.position = CGPointMake(CGRectGetMidX(frame) + 90, props.groundLevel + 20)
        
        addChild(speechBubble)
    }
    
    func basketManCries() {
        showSpeechBubble(SpeechBubbles.sniffle)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Close leaderboard (from GKGameCenterControllerDelegate)
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
