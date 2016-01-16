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
        
        musicPlayer.change("menu")
        
        Ads.showBanner()
        
        didPlayLoadingTransition = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler.handle(touches)
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
    
    private func changeButtonTexture(button: SKSpriteNode, _ name: String) {
        button.texture = SKTexture(imageNamed: name)
    }
}
