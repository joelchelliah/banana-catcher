import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var hWidth: CGFloat = 0.0
    var hHeight: CGFloat = 0.0
    var groundYOffset: CGFloat = -30.0
    
    
    var highScore: Int = 0
    
    private let homeNode = "home"
    private let retryNode = "retry"
    private let ratingNode = "rating"
    
    private let homeButton: SKSpriteNode = SKSpriteNode(imageNamed: "home.png")
    private let retryButton: SKSpriteNode = SKSpriteNode(imageNamed: "retry_button.png")
    private let ratingButton: SKSpriteNode = SKSpriteNode(imageNamed: "rate.png")
    private let ground: Ground = Ground()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        hWidth = size.width / 2
        hHeight = size.height / 2
        
        updateHighScore()
        
        addGround()
        addBackground()
        addBasketMan()
        addDarkness()
        addGameOverLabel()
        addEvilMonkey()
        addScoreBoard()
        addHomeBtn()
        addReplayBtn()
        addRatingBtn()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == retryNode) {
            moveToGameScene()
        } else if(touchedNode.name == homeNode) {
            moveToMenuScene()
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

    private func addGround() {
        ground.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height / 2 + groundYOffset)
        addChild(ground)
    }
    
    private func addBackground() {
        let xPos = CGRectGetMidX(frame)
        
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(xPos, sky.size.height / 2)
        sky.zPosition = -900
        addChild(sky)
        
        let rain = SKEmitterNode(fileNamed: "BananaRain")!
        rain.position = CGPointMake(xPos, size.height + 50)
        rain.zPosition = -800
        addChild(rain)
        
        
        let cliff = SKSpriteNode(imageNamed: "menu_ground.png")
        cliff.position = CGPointMake(xPos, cliff.size.height / 2 + groundYOffset)
        cliff.zPosition = -700
        addChild(cliff)
    }
    
    private func addBasketMan() {
        let basketMan: BasketManMenu = BasketManMenu()
        
        basketMan.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height + 10)
        basketMan.zPosition = -650
        addChild(basketMan)
    }
    
    private func addDarkness() {
        let topDarkness = SKSpriteNode(imageNamed: "darkness_top.png")
        let bottomDarkness = SKSpriteNode(imageNamed: "darkness_bottom.png")
        
        topDarkness.position = CGPointMake(hWidth, size.height + topDarkness.size.height / 2)
        bottomDarkness.position = CGPointMake(hWidth, -bottomDarkness.size.height / 2)
        
        topDarkness.runAction(SKAction.moveToY(size.height - topDarkness.size.height / 2, duration: 3))
        bottomDarkness.runAction(SKAction.moveToY(bottomDarkness.size.height / 2, duration: 3))
        
        [topDarkness, bottomDarkness].forEach {
            $0.zPosition = -600
            addChild($0)
        }
    }
    
    private func addGameOverLabel() {
        let label = GameOverLabel(x: hWidth, y: size.height - 55, zPosition: -500)
        
        addChild(label)
    }

    private func addEvilMonkey() {
        let monkey = EvilMonkey()
        monkey.position = CGPointMake(hWidth, size.height - 210)
        monkey.zPosition = -450
        monkey.alpha = 0.9
        
        let wait = SKAction.waitForDuration(3)
        let appear = SKAction.moveToY(size.height - 120, duration: 2)
        
        monkey.runAction(SKAction.sequence([wait, appear]))
        
        addChild(monkey)
    }
    
    private func addScoreBoard() {
        let scoreBoard = SKShapeNode(rect: CGRectMake(0, 0, 280, 120), cornerRadius: 5.0)
        scoreBoard.strokeColor = UIColor(netHex: 0x344a79)
        scoreBoard.fillColor = UIColor(netHex: 0x162031)
        scoreBoard.position = CGPointMake(hWidth - scoreBoard.frame.size.width / 2, hHeight - 10)
        scoreBoard.zPosition = -400
        addChild(scoreBoard)
        
        let labelStartY = hHeight + 80
        let scoreLabel1 = Label(name: "Score:", size: 25, x: hWidth, y: labelStartY)
        let scoreLabel2 = Label(name: score.description, size: 20, x: hWidth, y: labelStartY - 20)
        let scoreLabel3 = Label(name: "High Score:", size: 25, x: hWidth, y: labelStartY - 55)
        let scoreLabel4 = Label(name: highScore.description, size: 20, x: hWidth, y: labelStartY - 80)
        
        [scoreLabel1, scoreLabel2, scoreLabel3, scoreLabel4].forEach {
            $0.alpha = 0
            $0.zPosition = -300
            $0.runAction(SKAction.fadeAlphaTo(0.7, duration: 3))
            
            addChild($0)
        }
    }
    
    private func addReplayBtn() {
        retryButton.position = CGPointMake(hWidth, hHeight - 65)
        retryButton.name = retryNode
        retryButton.zPosition = -400

        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -8), duration: 4),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2)])
        
        retryButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(retryButton)
    }
    
    private func addHomeBtn() {
        homeButton.position = CGPointMake(hWidth - 100, hHeight - 75)
        homeButton.name = homeNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1)])
        
        homeButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(homeButton)
    }
    
    private func addRatingBtn() {
        ratingButton.position = CGPointMake(hWidth + 100, hHeight - 75)
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
}
