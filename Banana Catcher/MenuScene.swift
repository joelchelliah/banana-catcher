import UIKit
import SpriteKit

class MenuScene: SKScene {

    private let newGameNode = "newGame"
    private let soundNode = "toggleSound"
    
    private let ground: Ground = Ground()
    private let soundButton: SKSpriteNode = SKSpriteNode(imageNamed: "sound_on.png")
    
    private var menuTitleTextures = [SKTexture]()
    
    
    override func didMoveToView(view: SKView) {
        loadTextures()
        
        backgroundColor = bgColor
        addBackground()
        addGround()
        addBasketMan()
        addTitle()
        addStartBtn()
        addSoundBtn()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == newGameNode) {
            moveToGameScene()
        } else if(touchedNode.name == soundNode) {
            toggleSound()
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
        let basketMan: BasketMan = BasketMan()
        
        basketMan.position = CGPoint(x: CGRectGetMidX(frame), y: ground.size.height + 10)
        addChild(basketMan)
    }
    
    private func addTitle() {
        let title = SKSpriteNode(imageNamed: "menu_title_19.png")
        
        title.position = CGPointMake(size.width / 2, size.height - 75)
        
        let delay = SKAction.waitForDuration(2.0)
        let anim = SKAction.animateWithTextures(menuTitleTextures, timePerFrame: 0.05)

        title.runAction(SKAction.repeatActionForever(SKAction.sequence([delay, anim])))
        addChild(title)
    }
    
    private func addStartBtn() {
        let button = SKSpriteNode(imageNamed: "play_button.png")
        
        button.position = CGPointMake(size.width / 2, size.height - 225)
        button.name = newGameNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 8), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -12), duration: 3),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 1)])
        
        button.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(button)
    }
    
    private func addSoundBtn() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        soundEnabled = defaults.valueForKey("soundEnabled")?.boolValue ?? true
        defaults.synchronize()

        soundButton.position = CGPointMake(size.width / 2 - 100, size.height - 275)
        soundButton.name = soundNode
        setSoundBtnTexture()
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 2), duration: 1)])
        
        soundButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(soundButton)
    }
    
    
    /* Button actions */
    
    private func moveToGameScene() {
        let transitionType = SKTransition.flipVerticalWithDuration(0.5)
        let scene = GameScene(size: size)
        scene.scaleMode = scaleMode
        
        playSound(self, name: "option_select.wav")
        view?.presentScene(scene,transition: transitionType)
    }
    
    private func toggleSound() {
        soundEnabled = !soundEnabled
        
        playSound(self, name: "option_select.wav")
        setSoundBtnTexture()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(soundEnabled, forKey: "soundEnabled")
        defaults.synchronize()
    }
    
    private func setSoundBtnTexture() {
        let textures = [true: "sound_on.png", false: "sound_off.png"]
        
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.2)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.2)
        let setSound = SKAction.runBlock {
            self.soundButton.texture = SKTexture(imageNamed: textures[soundEnabled]!)
        }
        
        soundButton.runAction(SKAction.sequence([fadeOut, setSound, fadeIn]))
    }
    
    
    /* Misc */
    
    private func loadTextures() {
        for i in 1...19 {
            menuTitleTextures.append(SKTexture(imageNamed: "menu_title_\(i).png"))
        }
    }
}
