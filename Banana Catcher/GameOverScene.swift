import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var hWidth: CGFloat = 0.0
    var hHeight: CGFloat = 0.0
    
    var highScore: Int = 0
    
    let retryBtnNode = "retryBtn"
    
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        hWidth = size.width / 2
        hHeight = size.height / 2
        
        updateHighScore()
        
        addTitle()
        addScoreBoard()
        addReplayBtn()
        addFallingBananas()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == retryBtnNode){
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            
            let transitionType = SKTransition.flipVerticalWithDuration(0.5)
            view?.presentScene(scene,transition: transitionType)
        }
    }
    
    private func updateHighScore() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
        highScore = defaults.valueForKey("highScore")?.integerValue ?? 0
        print(highScore)
        defaults.synchronize()
    
        if score > highScore {
            highScore = score
            defaults.setObject(highScore, forKey: "highScore")
            defaults.synchronize()
        }
    }
    
    private func addTitle() {
        let title = RotatingText(fontNamed: gameFont)
        
        title.setTextFontSizeAndRotate("Game over!", theFontSize: 30)
        title.position = CGPointMake(hWidth, hHeight + 200)
        title.fontColor = UIColor.blackColor()
        addChild(title)
    }
    
    private func addScoreBoard() {
        let scoreBoard = SKShapeNode(rect: CGRectMake(0, 0, 300, 160), cornerRadius: 4.0)
        scoreBoard.fillColor = SKColor.blackColor()
        scoreBoard.alpha = 0.75
        scoreBoard.position = CGPointMake(hWidth - 150, hHeight - 50)
        addChild(scoreBoard)
        
        let bHeight = scoreBoard.frame.height
        scoreBoard.addChild(Label(name: "Score:", size: 30, x: hWidth, y: bHeight - 40))
        scoreBoard.addChild(Label(name: score.description, size: 25, x: hWidth, y: bHeight - 70))
        scoreBoard.addChild(Label(name: "High Score:", size: 30, x: hWidth, y: bHeight - 120))
        scoreBoard.addChild(Label(name: highScore.description, size: 25, x: hWidth, y: bHeight - 150))
    }
    
    private func addReplayBtn() {
        let btn = Label(name: "Retry?", size: 20, x: hWidth, y: hHeight - 100)
        btn.name = retryBtnNode
        addChild(btn)
    }
    
    private func addFallingBananas() {
        if let rain = SKEmitterNode(fileNamed: "BananaRain") {
            rain.position = CGPointMake(size.width/2, size.height + 50)
            rain.zPosition = -1000
            addChild(rain)
        }
    }
}
