import UIKit
import SpriteKit

class MenuScene: SKScene {

    let newGameNode = "newGame"
    
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        addTitle()
        addStartBtn()
        addFallingBananas()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == newGameNode){
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            
            let transitionType = SKTransition.flipVerticalWithDuration(0.5)
            view?.presentScene(scene,transition: transitionType)
        }
    }
    
    func addTitle() {
        let title = RotatingText(fontNamed: gameFont)
        
        title.setTextFontSizeAndRotate("Banana Catcher", theFontSize: 30)
        title.position = CGPointMake(size.width/2,size.height/2 + 200)
        title.fontColor = UIColor.blackColor()
        addChild(title)
    }
    
    func addStartBtn() {
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        
        startGameButton.position = CGPointMake(size.width / 2, size.height / 2 - 100)
        startGameButton.name = newGameNode
        addChild(startGameButton)
    }
    
    func addFallingBananas() {
        if let rain = SKEmitterNode(fileNamed: "BananaRain") {
            rain.position = CGPointMake(size.width/2, size.height + 50)
            rain.zPosition = -1000
            addChild(rain)
        }
    }
}
