import UIKit
import SpriteKit

class MenuScene: SKScene {

    private var hWidth: CGFloat = 0.0
    private var hHeight: CGFloat = 0.0
    
    private let playNode = "newGame"
    private let soundNode = "toggleSound"
    private let howToNode = "howTo"
    private let noAdsNode = "noAds"
    private let ratingNode = "rating"
    
    private let soundButton: SKSpriteNode = SKSpriteNode(imageNamed: "sound_on.png")
    private let howToButton: SKSpriteNode = SKSpriteNode(imageNamed: "how.png")
    private let playButton: SKSpriteNode = SKSpriteNode(imageNamed: "play_button.png")
    private let noAdsButton: SKSpriteNode = SKSpriteNode(imageNamed: "no_ads.png")
    private let ratingButton: SKSpriteNode = SKSpriteNode(imageNamed: "rate.png")
    
    private var menuTitleTextures = [SKTexture]()
    
    
    override func didMoveToView(view: SKView) {
        loadTextures()
        initSound()
        musicPlayer.change("menu")
        
        backgroundColor = bgColor
        hWidth = size.width / 2
        hHeight = size.height / 2
        
        addBackground()
        addBasketMan()
        addTitle()
        addSoundBtn()
        addTutorialBtn()
        addPlayBtn()
        addNoAdsBtn()
        addRatingBtn()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchLocation = touches.first!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == playNode) {
            moveToGameScene()
        } else if(touchedNode.name == soundNode) {
            toggleSound()
        } else if(touchedNode.name == howToNode) {
            moveToTutorialScene()
        } else if(touchedNode.name == noAdsNode) {
            toggleAds()
        } else if(touchedNode.name == ratingNode) {
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
    
    private func addSoundBtn() {
        soundButton.position = CGPointMake(size.width / 2 - 125, size.height - 330 + 2)
        soundButton.name = soundNode
        setSoundBtnTexture()
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 2), duration: 1)])
        
        soundButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(soundButton)
    }
    
    private func addTutorialBtn() {
        howToButton.position = CGPointMake(size.width / 2 - 90, size.height - 275 + 2)
        howToButton.name = howToNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2)])
        
        howToButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(howToButton)
    }
    
    private func addPlayBtn() {
        playButton.position = CGPointMake(size.width / 2, size.height - 225)
        playButton.name = playNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 8), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -12), duration: 3),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 1)])
        
        playButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(playButton)
    }
    
    private func addNoAdsBtn() {
        noAdsButton.position = CGPointMake(size.width / 2 + 90, size.height - 275 - 2)
        noAdsButton.name = noAdsNode
        
        // Keep to make restore button
        /*
        let fontColor = UIColor(netHex: 0x4D290C)
        let no = SKLabelNode(fontNamed: gameFont)
        no.fontColor = fontColor
        no.text = "No"
        no.fontSize = 10
        no.alpha = 0.8
        no.position = CGPointMake(no.position.x, no.position.y + 2)
        
        
        let ads = SKLabelNode(fontNamed: gameFont)
        ads.fontColor = fontColor
        ads.text = "Ads"
        ads.fontSize = 10
        ads.alpha = 0.8
        ads.position = CGPointMake(ads.position.x, no.position.y - 10)
        ads.zPosition = no.zPosition + 1
        
        
        let text = SKNode()
        
        text.addChild(no)
        text.addChild(ads)
        text.position = CGPointMake(size.width / 2 + 90, size.height - 270 - 2)
*/
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -4), duration: 2)])
        
        noAdsButton.runAction(SKAction.repeatActionForever(sequence))
        //text.runAction(SKAction.repeatActionForever(sequence))

        addChild(noAdsButton)
        //addChild(text)
    }
    
    private func addRatingBtn() {
        ratingButton.position = CGPointMake(size.width / 2 + 125, size.height - 330 - 2)
        ratingButton.name = ratingNode
        
        let sequence = SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: 4), duration: 2),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: -2), duration: 1)])
        
        ratingButton.runAction(SKAction.repeatActionForever(sequence))
        
        addChild(ratingButton)
    }
    
    /* Button actions */
    
    private func moveToGameScene() {
        buttonClickForNewScene(playButton, scene: GameScene(size: self.size))
    }
    
    private func moveToTutorialScene() {
        buttonClickForNewScene(howToButton, scene: TutorialScene(size: self.size))
    }
    
    private func buttonClickForNewScene(button: SKSpriteNode, scene: SKScene) {
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
        setSoundBtnTexture(true)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(soundEnabled, forKey: "soundEnabled")
        defaults.synchronize()
        
        musicPlayer.toggle()
    }
    
    private func setSoundBtnTexture(fromPress: Bool = false) {
        let textures = [true: "sound_on.png", false: "sound_off.png"]
        
        let fadeOut = SKAction.fadeAlphaTo(0.25, duration: 0.1)
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
        let sound = SKAction.runBlock { playSound(self, name: "option_select.wav") }
        let setTexture = SKAction.runBlock {
            self.soundButton.texture = SKTexture(imageNamed: textures[soundEnabled]!)
        }
        
        if fromPress {
            soundButton.runAction(SKAction.sequence([fadeOut, sound, setTexture, fadeIn]))
        } else {
            soundButton.runAction(setTexture)
        }
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
