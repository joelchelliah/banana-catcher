import UIKit
import SpriteKit

class MenuScene: SKScene, SpeechBubble {

    private var touchHandler: TouchHandler!
    private var props: PropsManager!
    private var basketMan: BasketManMenu!
    private var soundButton = SKSpriteNode()
    private var noAdsButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        touchHandler = MenuTouchHandler(forScene: self)

        props = MenuProps.init(forScene: self)
        props.add()
        
        basketMan = props.basketManMenu
        soundButton = props.soundButton
        noAdsButton = props.noAdsButton
        
        initSound()
        observeNoAdsNotifications()
        
        musicPlayer.change("menu")
        
        Ads.showBanner()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler.handle(touches)
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
        disableNoAdsButton()
        
        NoAds.restore()
        
        showSpeechBubble(SpeechBubbles.pleaseWait)
        basketManGoesQuietForAWhile()
        
        let wait = SKAction.waitForDuration(5)
        let purchase = SKAction.runBlock { NoAds.purchase() }
        let enableButtonUnlessPurchased = SKAction.runBlock {
            if !NoAds.alreadyPurchased() {
                self.noAdsButton.name = ButtonNodes.noAds
                self.noAdsButton.alpha = 1.0
            }
        }
        
        runAction(SKAction.sequence([wait, purchase, wait, enableButtonUnlessPurchased]))
    }
    
    internal func noAdsPurchased(_: NSNotification) {
        disableNoAdsButton()
        
        Ads.hideBanner()
        
        showSpeechBubble(SpeechBubbles.thankYou)
    }
    
    internal func noAdsAlreadyPurchased(_: NSNotification) {
        earlierTransactionRestored = true
        
        disableNoAdsButton()
        
        Ads.hideBanner()
        
        showSpeechBubble(SpeechBubbles.adsRestored)
    }
    
    private func disableNoAdsButton() {
        noAdsButton.name = ButtonNodes.noAdsDisabled
        noAdsButton.alpha = 0.3
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Speech bubble
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private var speechBubble = SKSpriteNode()
    
    func setSpeechBubble(bubble: SKSpriteNode) {
        speechBubble.removeFromParent()
        speechBubble = bubble
        speechBubble.position = CGPointMake(CGRectGetMidX(frame) + 90, props.groundLevel + 50)
        
        addChild(speechBubble)
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
        
        if soundEnabled {
            changeSoundButtonTexture("sound_on")
        }
        
        defaults.synchronize()
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Misc
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func basketManSaysHello() {
        showSpeechBubble(SpeechBubbles.hello)
    }
    
    func basketManGoesQuietForAWhile() {
        basketMan.name = ButtonNodes.basketManMenuQuiet
        
        let wait = SKAction.waitForDuration(8.0)
        let unmute = SKAction.runBlock { self.basketMan.name = ButtonNodes.basketManMenu }
        
        runAction(SKAction.sequence([wait, unmute]))
    }
    
    private func changeButtonTexture(button: SKSpriteNode, _ name: String) {
        button.texture = SKTexture(imageNamed: name)
    }
}
