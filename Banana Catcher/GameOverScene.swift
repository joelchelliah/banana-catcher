import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    private var hWidth: CGFloat = 0.0
    private var hHeight: CGFloat = 0.0
    
    var highScore: Int = 0
    
    private let homeNode = "home"
    private let highscoreNode = "highscore"
    private let retryNode = "retry"
    private let shareNode = "share"
    private let ratingNode = "rating"
    
    private let homeButton: SKSpriteNode = SKSpriteNode(imageNamed: "home.png")
    private let highscoreButton: SKSpriteNode = SKSpriteNode(imageNamed: "highscore.png")
    private let retryButton: SKSpriteNode = SKSpriteNode(imageNamed: "retry_button.png")
    private let ratingButton: SKSpriteNode = SKSpriteNode(imageNamed: "rate.png")
    private let shareButton: SKSpriteNode = SKSpriteNode(imageNamed: "share.png")
    
    private var tearsTextures = [SKTexture]()
    private var sobTextures = [SKTexture]()
    private var scoreboardTextures = [SKTexture]()
    
    override func didMoveToView(view: SKView) {
        musicPlayer.change("game_over")
        
        backgroundColor = bgColor
        hWidth = size.width / 2
        hHeight = size.height / 2
        
        loadTextures()
        updateHighScore()
        
        addBackground()
        addGameOverTears()
        addDarkness()
        addGameOverLabel()
        addScoreBoard()
        addButtons()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == homeNode) {
            moveToMenuScene()
        } else if(touchedNode.name == highscoreNode) {
            // TODO!
        } else if(touchedNode.name == retryNode) {
            moveToGameScene()
        } else if(touchedNode.name == shareNode) {
            displaySharingPopup()
        } else if(touchedNode.name == ratingNode) {
            // TODO!
        }
    }
    
    private func updateHighScore() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
        highScore = defaults.valueForKey("highScore")?.integerValue ?? 0
        defaults.synchronize()
    
        if score > highScore {
            highScore = score
            defaults.setObject(highScore, forKey: "highScore")
            defaults.synchronize()
        }
    }
    
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
        let cliff = SKSpriteNode(imageNamed: "game_over_tears_1.png")
        cliff.position = CGPointMake(hWidth, cliff.size.height / 2)
        cliff.zPosition = -700
        
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
        let labelStartY = hHeight + 110
        
        let scoreBoard = SKSpriteNode(imageNamed: "scoreboard_1.png")
        scoreBoard.position = CGPointMake(hWidth, labelStartY)
        scoreBoard.zPosition = -500
        addChild(scoreBoard)
        
        let animation = SKAction.animateWithTextures(scoreboardTextures, timePerFrame: 0.08)
        let fly = SKAction.repeatActionForever(animation)
        
        scoreBoard.runAction(fly)
        
        let scoreLabel1 = Label(name: "Score:", size: 25, x: hWidth, y: labelStartY)
        let scoreLabel2 = Label(name: score.description, size: 20, x: hWidth, y: labelStartY - 20)
        let scoreLabel3 = Label(name: "High Score:", size: 25, x: hWidth, y: labelStartY - 55)
        let scoreLabel4 = Label(name: highScore.description, size: 20, x: hWidth, y: labelStartY - 80)
        
        [scoreLabel1, scoreLabel2, scoreLabel3, scoreLabel4].forEach {
            $0.alpha = 0
            $0.zPosition = -490
            $0.runAction(SKAction.fadeAlphaTo(0.7, duration: 3))
            
            addChild($0)
        }
    }
    
    private func addButtons() {
        let yPos = hHeight - 30
        
        addHomeBtn(yPos)
        addHighscoreBtn(yPos)
        addReplayBtn(yPos)
        addShareBtn(yPos)
        addRatingBtn(yPos)
    }
    
    private func addHomeBtn(yPos: CGFloat) {
        homeButton.position = CGPointMake(hWidth - 125, yPos - 80)
        homeButton.name = homeNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1)])
        
        homeButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(homeButton)
    }
    
    private func addHighscoreBtn(yPos: CGFloat) {
        highscoreButton.position = CGPointMake(hWidth - 80, yPos - 40)
        highscoreButton.name = highscoreNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1)])
        
        highscoreButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(highscoreButton)
    }
    
    private func addReplayBtn(yPos: CGFloat) {
        retryButton.position = CGPointMake(hWidth, yPos)
        retryButton.name = retryNode
        retryButton.zPosition = -500
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -8), duration: 4),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2)])
        
        retryButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(retryButton)
    }
    
    private func addShareBtn(yPos: CGFloat) {
        shareButton.position = CGPointMake(hWidth + 80, yPos - 40)
        shareButton.name = shareNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1)])
        
        shareButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(shareButton)
    }
    
    private func addRatingBtn(yPos: CGFloat) {
        ratingButton.position = CGPointMake(hWidth + 125, yPos - 80)
        ratingButton.name = ratingNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1)])
        
        ratingButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(ratingButton)
    }
    
    private func moveToGameScene() {
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { playSound(self, name: "option_select.wav") }
        let transition = SKAction.runBlock {
            let scene = GameScene(size: self.size)
            scene.scaleMode = self.scaleMode
            
            self.view?.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(0.5))
        }
        
        retryButton.runAction(SKAction.sequence([fadeOut, sound, fadeIn, transition]))
    }
    
    private func moveToMenuScene() {
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { playSound(self, name: "option_select.wav") }
        let transition = SKAction.runBlock {
            let scene = MenuScene(size: self.size)
            scene.scaleMode = self.scaleMode
            
            self.view?.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(0.5))
        }
        
        homeButton.runAction(SKAction.sequence([fadeOut, sound, fadeIn, transition]))
    }
    
    private func displaySharingPopup() {
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
        
        self.view?.window?.rootViewController?.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    private func loadTextures() {
        tearsTextures = (1...5).map { SKTexture(imageNamed: "game_over_tears_\($0).png") }
        sobTextures = (1...10).map { SKTexture(imageNamed: "game_over_sob_\($0).png") }
        scoreboardTextures = (1...8).map { SKTexture(imageNamed: "scoreboard_\($0).png") }
    }
}
