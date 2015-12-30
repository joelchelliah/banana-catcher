import UIKit
import SpriteKit
import GameKit

class GameOverScene: SKScene, GKGameCenterControllerDelegate, SpeechBubble  {
    
    private var hWidth: CGFloat = 0.0
    private var hHeight: CGFloat = 0.0
    
    private var touchHandler: TouchHandler!
    
    var highScore: Int = 0
    
    private var tearsTextures = [SKTexture]()
    private var sobTextures = [SKTexture]()
    private var scoreboardTextures = [SKTexture]()
    private var sniffleTextures = [SKTexture]()
    
    private let cliff = SKSpriteNode(imageNamed: "game_over_tears_1.png")
    
    override func didMoveToView(view: SKView) {
        hWidth = size.width / 2
        hHeight = size.height / 2
        touchHandler = GameOverTouchHandler(forScene: self)
        
        musicPlayer.change("game_over")
        
        loadTextures()
        updateHighScore()
        addBackground()
        addGameOverTears()
        addDarkness()
        addGameOverLabel()
        addScoreBoard()
        addButtons()
        
        Ads.hideBanner()
        Ads.showInterstitial()
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
            } else {
                print("Score submitted")
            }
        })
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Add game elements
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func addBackground() {
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(hWidth, sky.size.height / 2)
        sky.zPosition = -900
        addChild(sky)
        
        let rain = SKEmitterNode(fileNamed: "BananaRain")!
        rain.position = CGPointMake(hWidth, size.height + 50)
        rain.zPosition = -800
        addChild(rain)
    }
    
    private func addGameOverTears() {
        cliff.position = CGPointMake(hWidth, cliff.size.height / 2)
        cliff.zPosition = -700
        cliff.name = ButtonNodes.basketManMenu
        
        let tears = SKAction.animateWithTextures(tearsTextures, timePerFrame: 0.08)
        let cry = SKAction.repeatAction(tears, count: 5)
        let sob = SKAction.animateWithTextures(sobTextures, timePerFrame: 0.08)
        
        cliff.runAction(SKAction.repeatActionForever(SKAction.sequence([cry, sob])))
        
        addChild(cliff)
    }
    
    private func addDarkness() {
        let topDarkness = SKSpriteNode(imageNamed: "darkness_top.png")
        let bottomDarkness = SKSpriteNode(imageNamed: "darkness_bottom.png")
        
        topDarkness.size.height *= 0.75
        //bottomDarkness.size.height *= 0.85
        
        topDarkness.position = CGPointMake(hWidth, size.height - topDarkness.size.height / 2)
        bottomDarkness.position = CGPointMake(hWidth, bottomDarkness.size.height / 2 - 130)
        
        [topDarkness, bottomDarkness].forEach {
            $0.zPosition = -600
            
            addChild($0)
        }
    }
    
    private func addGameOverLabel() {
        let label = GameOverLabel(x: hWidth, y: size.height - 55, zPosition: -500)
        
        addChild(label)
    }
    
    private func addScoreBoard() {
        let yPos = hHeight + 110
        
        let scoreBoard = SKSpriteNode(imageNamed: "scoreboard_1.png")
        scoreBoard.position = CGPointMake(hWidth, yPos)
        scoreBoard.zPosition = -500
        addChild(scoreBoard)
        
        let animation = SKAction.animateWithTextures(scoreboardTextures, timePerFrame: 0.08)
        let fly = SKAction.repeatActionForever(animation)
        
        scoreBoard.runAction(fly)
        
        let label1 = ScoreboardLabel(name: "Score:", size: 23, x: hWidth, y: yPos)
        let label2 = ScoreboardLabel(name: score.description, size: 18, x: hWidth, y: yPos - 20)
        let label3 = ScoreboardLabel(name: "High Score:", size: 23, x: hWidth, y: yPos - 55)
        let label4 = ScoreboardLabel(name: highScore.description, size: 18, x: hWidth, y: yPos - 75)
        
        [label1, label2, label3, label4].forEach {
            $0.zPosition = -490
            
            addChild($0)
        }
    }
    
    private func addButtons() {
        let buttonGenerator = ButtonGenerator(forScene: self, yBasePos: hHeight - 30)
        
        buttonGenerator.generate()
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Speech bubble
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var speechBubble = SKSpriteNode()
    
    func setSpeechBubble(bubble: SKSpriteNode) {
        speechBubble.removeFromParent()
        speechBubble = bubble
        speechBubble.position = CGPointMake(hWidth + 90, cliff.size.height + 20)
        
        addChild(speechBubble)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Misc
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func basketManCries() {
        showSpeechBubble(sniffleTextures)
    }
    
    private func loadTextures() {
        tearsTextures = (1...5).map { SKTexture(imageNamed: "game_over_tears_\($0).png") }
        sobTextures = (1...10).map { SKTexture(imageNamed: "game_over_sob_\($0).png") }
        scoreboardTextures = (1...8).map { SKTexture(imageNamed: "scoreboard_\($0).png") }
        sniffleTextures = (1...7).map { SKTexture(imageNamed: "sniffle_\($0).png") }
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Close leaderboard (from GKGameCenterControllerDelegate)
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
