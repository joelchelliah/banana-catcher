import UIKit
import SpriteKit

class MenuScene: SKScene {

    private var hWidth: CGFloat = 0.0
    private var hHeight: CGFloat = 0.0
    
    private var touchHandler: TouchHandler!

    private var titleTextures = [SKTexture]()
    private var pleaseWaitTextures = [SKTexture]()
    private var adsRestoredTextures = [SKTexture]()
    
    private var soundButton = SKSpriteNode()
    private var noAdsButton = SKSpriteNode()
    
    private let ground = SKSpriteNode(imageNamed: "menu_ground.png")
    
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
        
        observeNoAdsNotifications()
        
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
        let anim = SKAction.animateWithTextures(titleTextures, timePerFrame: 0.05)

        title.runAction(SKAction.repeatActionForever(SKAction.sequence([delay, anim])))
        addChild(title)
    }
    
    private func addButtons() {
        let buttonGenerator = ButtonGenerator(forScene: self, yBasePos: size.height - 225)
        
        buttonGenerator.generate()
        
        soundButton = buttonGenerator.soundButton
        noAdsButton = buttonGenerator.noAdsButton
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Store (no ads)
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func observeNoAdsNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noAdsPurchased:", name: NoAds.purchasedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noAdsAlreadyPurchased:", name: NoAds.alreadyPurchasedNotification, object: nil)
        
        if NoAds.alreadyPurchased() || NoAds.notPermitted() {
            disableNoAdsButton()
        }
    }
    
    func purchaseNoAds() {
        NoAds.purchase()
        
        showSpeechBubble(pleaseWaitTextures)
    }
    
    internal func noAdsPurchased(_: NSNotification) {
        disableNoAdsButton()
        BannerAds.hide()
    }
    
    internal func noAdsAlreadyPurchased(_: NSNotification) {
        disableNoAdsButton()
        BannerAds.hide()
        
        showSpeechBubble(adsRestoredTextures)
    }
    
    private func showSpeechBubble(textures: [SKTexture]) {
        let bubble = SKSpriteNode(texture: textures.first)
        let pos = CGPointMake(hWidth + +90, ground.size.height + 50)

        let wait = SKAction.waitForDuration(2.0)
        let show = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        let hide = SKAction.animateWithTextures(textures.reverse(), timePerFrame: 0.05)
        let remove = SKAction.removeFromParent()

        bubble.position = pos
        bubble.zPosition = -400
        bubble.runAction(SKAction.sequence([show, wait, hide, remove]))
        
        addChild(bubble)
    }
    
    private func disableNoAdsButton() {
        noAdsButton.name = ButtonNodes.noAdsDisabled
        noAdsButton.alpha = 0.3
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Sound
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func changeSoundButtonTexture(name: String) {
        changeButtonTexture(soundButton, name)
    }
    
    private func initSound() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        soundEnabled = defaults.valueForKey("soundEnabled")?.boolValue ?? true
        
        defaults.synchronize()
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Misc
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func changeButtonTexture(button: SKSpriteNode, _ name: String) {
        button.texture = SKTexture(imageNamed: name)
    }
    
    private func loadTextures() {
        for i in 1...19 { titleTextures.append(SKTexture(imageNamed: "menu_title_\(i).png")) }
        for i in 1...7 { pleaseWaitTextures.append(SKTexture(imageNamed: "please_wait_\(i).png")) }
        for i in 1...7 { adsRestoredTextures.append(SKTexture(imageNamed: "ads_restored_\(i).png")) }
    }
}
