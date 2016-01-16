import UIKit
import SpriteKit

class ShopScene: SKScene, SpeechBubble {
    
    private var touchHandler: TouchHandler!
    private var props: PropsManager!
    private var basketMan: BasketManMenu!
    private var purchaseButton = SKSpriteNode()
    private var restoreButton = SKSpriteNode()
    private var backButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        touchHandler = ShopTouchHandler(forScene: self)
        
        props = ShopProps.init(forScene: self)
        props.add()
        
        basketMan = props.basketManMenu
        purchaseButton = props.purchaseButton
        restoreButton = props.restoreButton
        backButton = props.backButton
        
        observeNoAdsNotifications()
        
        musicPlayer.change("tutorial")
        
        Ads.showBanner()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler.handle(touches)
    }
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * No Ads
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func observeNoAdsNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noAdsPurchased:", name: NoAds.purchasedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noAdsRestored:", name: NoAds.restoredNotification, object: nil)
        
        if NoAds.alreadyPurchased() || NoAds.notPermitted() {
            disableShopButtons()
        }
    }
    
    func purchaseNoAds() {
        doNoAdsTransaction(NoAds.purchase)
    }
    
    func restoreNoAds() {
        doNoAdsTransaction(NoAds.restore)
    }
    
    private func doNoAdsTransaction(transaction: () -> ()) {
        disableShopButtons()
        
        transaction()

        basketManWaits()
        
        let wait = SKAction.waitForDuration(5)
        let enableButtonUnlessPurchased = SKAction.runBlock {
            if !NoAds.alreadyPurchased() {
                self.enableShopButtons()
            }
        }
        
        runAction(SKAction.sequence([wait, enableButtonUnlessPurchased]))
    }
    
    internal func noAdsPurchased(_: NSNotification) {
        disableShopButtons()
        
        Ads.hideBanner()
        
        showSpeechBubble(SpeechBubbles.thankYou)
    }
    
    internal func noAdsRestored(_: NSNotification) {
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
    
    private func basketManWaits() {
        showSpeechBubble(SpeechBubbles.pleaseWait)
        
        basketMan.name = ButtonNodes.basketManMenuQuiet
        
        let wait = SKAction.waitForDuration(8.0)
        let unmute = SKAction.runBlock { self.basketMan.name = ButtonNodes.basketManMenu }
        
        runAction(SKAction.sequence([wait, unmute]))
    }
}
