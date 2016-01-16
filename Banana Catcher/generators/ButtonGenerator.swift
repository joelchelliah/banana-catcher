import Foundation
import SpriteKit

class ButtonGenerator: Generator {
    
    private var buttonPositions: [CGPoint]!
    private var buttonAnimations: [SKAction]!
    
    override init(forScene scene: SKScene, yBasePos: CGFloat, fromZPos: CGFloat = -800) {
        super.init(forScene: scene, yBasePos: yBasePos)
        
        buttonPositions = initButtonPositions()
        buttonAnimations = initButtonAnimations()
    }
    
    override func generate() {
        switch scene {
        case is MenuScene:
            generateMenuButtons()
        case is TutorialScene:
            generateTutorialButtons()
        case is GameOverScene:
            generateGameOverButtons()
        default:
            fatalError("Called generate buttons for unexpected scene: \(scene.name)")
        }
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Menu buttons
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var soundButton = SKSpriteNode(texture: Textures.soundOff)
    var noAdsButton = SKSpriteNode(imageNamed: "no_ads.png")
    
    private func generateMenuButtons() {
        generateSoundButton()
        generateTutorialButton()
        generatePlayButton()
        generateNoAdsButton()
        generateRatingButton()
    }
    
    private func generateSoundButton() {
        if soundEnabled {
            soundButton.texture = Textures.soundOn
        }
        generateButton(soundButton, name: ButtonNodes.sound, index: ButtonPositions.leftest)
    }
    
    private func generateTutorialButton() {
        let button = SKSpriteNode(imageNamed: "how.png")
        
        generateButton(button, name: ButtonNodes.howTo, index: ButtonPositions.left)
    }
    
    private func generatePlayButton() {
        let button = SKSpriteNode(imageNamed: "play_button.png")

        generateButton(button, name: ButtonNodes.play, index: ButtonPositions.mid)
    }
    
    private func generateNoAdsButton() {
        if NoAds.alreadyPurchased() || NoAds.notPermitted() {
            noAdsButton.name = ButtonNodes.disabled
            noAdsButton.alpha = 0.3
        }
        generateButton(noAdsButton, name: ButtonNodes.noAds, index: ButtonPositions.right)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Tutorial buttons
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var nextButton = SKSpriteNode(texture: Textures.next)
    
    private func generateTutorialButtons() {
        generateButton(nextButton, name: ButtonNodes.next, index: ButtonPositions.mid)
    }

    
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Shop buttons
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var purchaseButton = SKSpriteNode(texture: Textures.purchase)
    var restoreButton = SKSpriteNode(texture: Textures.restore)
    var backButton = SKSpriteNode(texture: Textures.back)
    
    private func generateShopButtons() {
        generateButton(purchaseButton, name: ButtonNodes.purchase, index: ButtonPositions.left)
        generateButton(restoreButton, name: ButtonNodes.restore, index: ButtonPositions.right)
        generateButton(restoreButton, name: ButtonNodes.back, index: ButtonPositions.mid)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Game over buttons
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func generateGameOverButtons() {
        generateHomeButton()
        generateHighscoreButton()
        generateRetryButton()
        generateShareButton()
        generateRatingButton()
    }
    
    private func generateHomeButton() {
        let button = SKSpriteNode(imageNamed: "home.png")
        
        generateButton(button, name: ButtonNodes.home, index: ButtonPositions.leftest)
    }
    
    private func generateHighscoreButton() {
        let button = SKSpriteNode(imageNamed: "highscore.png")

        generateButton(button, name: ButtonNodes.highscore, index: ButtonPositions.left)
    }
    
    private func generateRetryButton() {
        let button = SKSpriteNode(imageNamed: "retry_button.png")

        generateButton(button, name: ButtonNodes.retry, index: ButtonPositions.mid)
    }
    
    private func generateShareButton() {
        let button = SKSpriteNode(imageNamed: "share.png")

        generateButton(button, name: ButtonNodes.share, index: ButtonPositions.right)
    }
    
    
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Common
    // * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func generateRatingButton() {
        let button = SKSpriteNode(imageNamed: "rate.png")

        generateButton(button, name: ButtonNodes.rating, index: ButtonPositions.rightest)
    }
    
    private func generateButton(button: SKSpriteNode, name: String, index i: Int) {
        let position = buttonPositions[i]
        let animation = buttonAnimations[i]
        let relativePosition = CGPointMake(hWidth + position.x, yBaseLevel + position.y)
        
        button.name = name
        button.position = relativePosition
        button.runAction(SKAction.repeatActionForever(animation))
        
        scene.addChild(button)
        
        // if !didPlayLoadingTransition { appearOnScreen(button) }
        switch scene {
        case is MenuScene, is ShopScene: appearOnScreen(button)
        default: break
        }
    }
    
    private func appearOnScreen(button: SKSpriteNode) {
        let size = button.size
        button.size.width = 0
        button.size.height = 0
        
        let wait = SKAction.waitForDuration(loadingTransitionDuration)
        let appear = SKAction.resizeToWidth(size.width, height: size.height, duration: loadingTransitionDuration)
        
        button.runAction(SKAction.sequence([wait, appear]))
    }
    
    private func initButtonPositions() -> [CGPoint] {
        let mid: CGFloat = 0
        let xInner: CGFloat = 90
        let xOuter: CGFloat = 125
        let yInner: CGFloat = -45
        let yOuter: CGFloat = -95
        let animationOffset: CGFloat = 4
        
        return [
            CGPointMake(-xOuter, yOuter),
            CGPointMake(-xInner, yInner + animationOffset),
            CGPointMake(mid, mid),
            CGPointMake(xInner, yInner),
            CGPointMake(xOuter, yOuter - animationOffset)
        ]
    }
    
    private func initButtonAnimations() -> [SKAction] {
        let up1: (Double, NSTimeInterval) = (4, 1)
        let up2: (Double, NSTimeInterval) = (8, 2)
        let down1: (Double, NSTimeInterval) = (-4, 1)
        let down2: (Double, NSTimeInterval) = (-8, 2)
        let down3: (Double, NSTimeInterval) = (-16, 4)
        
        return [
            makeButtonAnimation(d1: up1,  d2: down2,  d3: up1),
            makeButtonAnimation(d1: down1, d2: down1,  d3: up2),
            makeButtonAnimation(d1: up2,  d2: down3, d3: up2),
            makeButtonAnimation(d1: down1, d2: up2,   d3: down1),
            makeButtonAnimation(d1: up1,  d2: up1,   d3: down2)
        ]
    }
    
    private func makeButtonAnimation(d1 d1: (Double, NSTimeInterval), d2: (Double, NSTimeInterval), d3: (Double, NSTimeInterval)) -> SKAction {
        return SKAction.sequence([
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: d1.0), duration: d1.1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: d2.0), duration: d2.1),
            SKAction.moveBy(CGVector.init(dx: 0.0, dy: d3.0), duration: d3.1)
            ])
    }
}
