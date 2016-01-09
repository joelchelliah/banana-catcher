import Foundation
import SpriteKit

class MenuProps: PropsManager {
    
    // Height offsets from top
    private let labelOffset: CGFloat = 50
    private let buttonsOffset: CGFloat = 180
    private let loadingOffset: CGFloat = 200
    private let basketOffset: CGFloat = 305
    private let groundOffset: CGFloat = 470
    
    init(forScene scene: MenuScene) {
        super.init(forScene: scene)
    }
    
    override func add() {
        addBackground()
        addBasketMan()
        addTitle()
        addLoadingText()
        addButtons()
    }
    
    
    private func addBackground() {
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(hWidth, sky.size.height / 2)
        
        let rain = Emitters.rain
        rain.position = CGPointMake(hWidth, height + 50)
        
        let offset = groundOffset + screenHeightOffset()
        let ground = SKSpriteNode(imageNamed: "menu_ground.png")
        ground.position = CGPointMake(hWidth, height - offset)
        
        [sky, rain, ground].forEach {
            $0.zPosition = nextZ()
            
            scene.addChild($0)
        }
        
        groundLevel = height - offset + 130
    }
    
    private func addBasketMan() {
        let offset = basketOffset + screenHeightOffset()
        
        basketManMenu = BasketManMenu()
        basketManMenu.position = CGPoint(x: hWidth, y: height - offset)
        basketManMenu.name = ButtonNodes.basketManMenu
        
        scene.addChild(basketManMenu)
    }
    
    private func addTitle() {
        let textures = Textures.title
        
        let wait = SKAction.waitForDuration(2.0)
        let anim = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        let loop = SKAction.repeatActionForever(SKAction.sequence([wait, anim]))
        
        let title = SKSpriteNode(texture: textures.last)
        title.position = CGPoint(x: hWidth, y: height - labelOffset)
        
        scene.addChild(title)
        
        if didPlayLoadingTransition {
            title.runAction(loop)
        } else {
            let appear = SKAction.fadeAlphaTo(1.0, duration: 2.0 * loadingTransitionDuration)
            
            title.alpha = 0
            title.runAction(SKAction.sequence([appear, loop]))
        }
    }
    
    private func addLoadingText() {
        if didPlayLoadingTransition { return }
        
        let offset = loadingOffset + screenHeightOffset() * 0.8
        let scaleFactor = 1.0 + screenHeightOffset() / 1000
        
        let disappear = SKAction.fadeAlphaTo(0, duration: loadingTransitionDuration)
        let remove = SKAction.removeFromParent()
        
        let loading = SKSpriteNode(texture: Textures.loading)
        loading.size.width *= scaleFactor
        loading.size.height *= scaleFactor
        loading.position = CGPoint(x: hWidth, y: height - offset)
        loading.zPosition = nextZ()
        loading.runAction(SKAction.sequence([disappear, remove]))
        
        scene.addChild(loading)
    }
    
    private func addButtons() {
        let offset = buttonsOffset + screenHeightOffset() / 2
        
        let buttonGenerator = ButtonGenerator(forScene: scene, yBasePos: height - offset)
        
        buttonGenerator.generate()
        
        soundButton = buttonGenerator.soundButton
        noAdsButton = buttonGenerator.noAdsButton
    }
}
