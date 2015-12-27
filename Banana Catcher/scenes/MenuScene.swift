import UIKit
import SpriteKit

class MenuScene: SKScene {

    private var hWidth: CGFloat = 0.0
    private var hHeight: CGFloat = 0.0
    
    private var touchHandler: TouchHandler!

    private var menuTitleTextures = [SKTexture]()
    
    private var soundButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        hWidth = size.width / 2
        hHeight = size.height / 2
        touchHandler = MenuTouchHandler(forScene: self)
        
        initSound()
        loadTextures()
        
        musicPlayer.change("menu")

        addBackground()
        addBasketMan()
        addTitle()
        addButtons()
        
        BannerAds.show()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler.handle(touches)
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
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Sound
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func changeSoundButtonTexture(name: String) {
        soundButton.texture = SKTexture(imageNamed: name)
    }
    
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
