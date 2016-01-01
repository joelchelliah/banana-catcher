import Foundation
import SpriteKit

class MenuProps: PropsManager {
    
    init(forScene scene: MenuScene) {
        super.init(forScene: scene)
    }
    
    override func add() {
        addBackground()
        addBasketMan()
        addTitle()
        addButtons()
    }
    
    
    private func addBackground() {
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(hWidth, sky.size.height / 2)
        
        let rain = SKEmitterNode(fileNamed: "BananaRain")!
        rain.position = CGPointMake(hWidth, height + 50)
        
        let ground = SKSpriteNode(imageNamed: "menu_ground.png")
        ground.position = CGPointMake(hWidth, ground.size.height / 2)
        
        [sky, rain, ground].forEach {
            $0.zPosition = nextZ()
            
            scene.addChild($0)
        }
        
        groundLevel = ground.size.height
    }
    
    private func addBasketMan() {
        basketManMenu = BasketManMenu()
        basketManMenu.position = CGPoint(x: hWidth, y: groundLevel + 35)
        basketManMenu.name = ButtonNodes.basketManMenu
        
        scene.addChild(basketManMenu)
    }
    
    private func addTitle() {
        let textures = texturesFor(name: "menu_title", numFrames: 19)
        let delay = SKAction.waitForDuration(2.0)
        let anim = SKAction.animateWithTextures(textures, timePerFrame: 0.05)
        
        let title = SKSpriteNode(texture: textures.last)
        title.position = CGPoint(x: hWidth, y: height - 65)
        title.runAction(SKAction.repeatActionForever(SKAction.sequence([delay, anim])))
        
        scene.addChild(title)
    }
    
    private func addButtons() {
        let buttonGenerator = ButtonGenerator(forScene: scene, yBasePos: height - 225)
        
        buttonGenerator.generate()
        
        soundButton = buttonGenerator.soundButton
        noAdsButton = buttonGenerator.noAdsButton
    }
}
