import UIKit
import SpriteKit

class ShopScene: SKScene, SpeechBubble {
    
    private var touchHandler: TouchHandler!
    private var props: PropsManager!
    private var basketMan: BasketManMenu!
    private var purchaseButton = SKSpriteNode()
    private var restoreButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        touchHandler = MenuTouchHandler(forScene: self)
        
        props = MenuProps.init(forScene: self)
        props.add()
        
        basketMan = props.basketManMenu
        purchaseButton = props.purchaseButton
        restoreButton = props.restoreButton
        
        observeNoAdsNotifications()
        
        musicPlayer.change("tutorial")
        
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
            disableShopButtons()
        }
    }
    
    func purchaseNoAds() {
        disableShopButtons()
        
        NoAds.restore()
        
        showSpeechBubble(SpeechBubbles.pleaseWait)
        basketManGoesQuietForAWhile()
        
        let wait = SKAction.waitForDuration(5)
        let purchase = SKAction.runBlock { NoAds.purchase() }
        let enableButtonUnlessPurchased = SKAction.runBlock {
            if !NoAds.alreadyPurchased() {
                self.enableShopButtons()
            }
        }
        
        runAction(SKAction.sequence([wait, purchase, wait, enableButtonUnlessPurchased]))
    }
    
    internal func noAdsPurchased(_: NSNotification) {
        disableShopButtons()
        
        Ads.hideBanner()
        
        showSpeechBubble(SpeechBubbles.thankYou)
    }
    
    internal func noAdsAlreadyPurchased(_: NSNotification) {
        earlierTransactionRestored = true
        
        disableShopButtons()
        
        Ads.hideBanner()
        
        showSpeechBubble(SpeechBubbles.adsRestored)
    }
    
    private func enableShopButtons() {
        [purchaseButton, restoreButton].forEach { $0.alpha = 1.0 }
        
        purchaseButton.name = ButtonNodes.purchase
        restoreButton.name = ButtonNodes.restore
    }
    
    private func disableShopButtons() {
        [purchaseButton, restoreButton].forEach {
            $0.name = ButtonNodes.disabled
            $0.alpha = 0.3
        }
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
    
    func basketManSaysHello() {
        showSpeechBubble(SpeechBubbles.hello)
    }
    
    func basketManGoesQuietForAWhile() {
        basketMan.name = ButtonNodes.basketManMenuQuiet
        
        let wait = SKAction.waitForDuration(8.0)
        let unmute = SKAction.runBlock { self.basketMan.name = ButtonNodes.basketManMenu }
        
        runAction(SKAction.sequence([wait, unmute]))
    }
}
