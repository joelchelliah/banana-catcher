import UIKit
import SpriteKit

class MenuScene: SKScene {

    let newGameNode = "newGame"
    let ground: Ground = Ground()
    let basketMan: BasketMan = BasketMan()
    
    override func didMoveToView(view: SKView) {
        backgroundColor = bgColor
        addBackground()
        addGround()
        addBasketMan()
        addTitle()
        addStartBtn()
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
    
    private func addBackground() {
        let xPos = CGRectGetMidX(frame)
        
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(xPos, sky.size.height / 2)
        sky.zPosition = -999
        addChild(sky)
        
        let rain = SKEmitterNode(fileNamed: "BananaRain")!
        rain.position = CGPointMake(xPos, size.height + 50)
        rain.zPosition = -888
        addChild(rain)
        
        
        let ground = SKSpriteNode(imageNamed: "menu_ground.png")
        ground.position = CGPointMake(xPos, ground.size.height / 2)
        ground.zPosition = -777
        addChild(ground)
    }
    
    private func addGround() {
        ground.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height / 2)
        addChild(ground)
    }
    
    private func addBasketMan() {
        basketMan.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height + 10)
        addChild(basketMan)
    }
    
    private func addTitle() {
        let title = RotatingText(fontNamed: gameFont)
        
        title.setTextFontSizeAndRotate("Banana Catcher", theFontSize: 30)
        title.position = CGPointMake(size.width / 2, size.height - 100)
        title.fontColor = UIColor.blackColor()
        addChild(title)
    }
    
    private func addStartBtn() {
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        
        startGameButton.position = CGPointMake(size.width / 2, size.height - 200)
        startGameButton.name = newGameNode
        addChild(startGameButton)
    }
}
