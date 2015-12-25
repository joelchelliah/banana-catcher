import UIKit
import SpriteKit

class MenuScene: SKScene {

    private var hWidth: CGFloat = 0.0
    private var hHeight: CGFloat = 0.0

    private var soundButton = SKSpriteNode()
    private var menuTitleTextures = [SKTexture]()
    
    override func didMoveToView(view: SKView) {
        hWidth = size.width / 2
        hHeight = size.height / 2
        
        initSound()
        loadTextures()
        
        musicPlayer.change("menu")

        addBackground()
        addBasketMan()
        addTitle()
        addButtons()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        let nodes = ButtonNodes.self
        
        if(touchedNode.name == nodes.sound) {
            toggleSound()
        } else if(touchedNode.name == nodes.howTo) {
            moveToTutorialScene(touchedNode)
        } else if(touchedNode.name == nodes.play) {
            moveToGameScene(touchedNode)
        } else if(touchedNode.name == nodes.noAds) {
            toggleAds()
        } else if(touchedNode.name == nodes.rating) {
            // TODO!
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
    
    private func addBasketMan() {
        let basketMan: BasketManMenu = BasketManMenu()
        
        basketMan.position = CGPointMake(hWidth, hHeight - 88)
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
    
    private func addButtons() {
        let buttonGenerator = ButtonGenerator(forScene: self, yBasePos: size.height - 225)
        
        buttonGenerator.generate()
        
        soundButton = buttonGenerator.soundButton
    }
    
    
    /* Button actions */
    
    private func moveToGameScene(node: SKNode) {
        buttonClickForNewScene(node, scene: GameScene(size: self.size))
    }
    
    private func moveToTutorialScene(node: SKNode) {
        buttonClickForNewScene(node, scene: TutorialScene(size: self.size))
    }
    
    private func buttonClickForNewScene(button: SKNode, scene: SKScene) {
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { playSound(self, name: "option_select.wav") }
        let transition = SKAction.runBlock {
            scene.scaleMode = self.scaleMode
            self.view?.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(0.5))
        }
        
        button.runAction(SKAction.sequence([fadeOut, sound, fadeIn, transition]))
    }
    
    private func toggleAds() {
        // TODO!
        playSound(self, name: "option_select.wav")
    }
    
    private func toggleSound() {
        soundEnabled = !soundEnabled
        setSoundBtnTexture()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(soundEnabled, forKey: "soundEnabled")
        defaults.synchronize()
        
        musicPlayer.toggle()
    }
    
    private func setSoundBtnTexture() {
        let textures = [true: "sound_on.png", false: "sound_off.png"]
        
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { playSound(self, name: "option_select.wav") }
        let setTexture = SKAction.runBlock {
            self.soundButton.texture = SKTexture(imageNamed: textures[soundEnabled]!)
        }
        soundButton.runAction(SKAction.sequence([fadeOut, sound, setTexture, fadeIn]))
    }
    
    
    /* Misc */
    
    private func initSound() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        soundEnabled = defaults.valueForKey("soundEnabled")?.boolValue ?? true
        defaults.synchronize()
    }
    
    private func loadTextures() {
        for i in 1...19 {
            menuTitleTextures.append(SKTexture(imageNamed: "menu_title_\(i).png"))
        }
    }
}
