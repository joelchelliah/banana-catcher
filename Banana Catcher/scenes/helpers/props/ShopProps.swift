import Foundation
import SpriteKit

class ShopProps: PropsManager {
    
    // Height offsets from top
    private let headerOffset: CGFloat = 50
    private let infoOffset: CGFloat = 90
    private let buttonsOffset: CGFloat = 180
    private let basketOffset: CGFloat = 305
    private let groundOffset: CGFloat = 470
    
    init(forScene scene: ShopScene) {
        super.init(forScene: scene)
    }
    
    override func add() {
        addBackground()
        addBasketMan()
        addDarkness()
        addLabels()
        addButtons()
    }
    
    
    private func addBackground() {
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(hWidth, sky.size.height / 2)
        
        let rain = SKEmitterNode(fileNamed: "BananaRain")!
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
    
    private func addDarkness() {
        let top = SKSpriteNode(imageNamed: "darkness_top.png")
        let bot = SKSpriteNode(imageNamed: "darkness_bottom.png")
        
        [top, bot].forEach { $0.size.width *= 1.5 }
        
        top.size.height *= 0.5
        top.size.height += screenHeightOffset() / 2
        
        bot.size.height *= 0.7
        
        top.position = CGPointMake(hWidth, height - top.size.height / 2)
        bot.position = CGPointMake(hWidth, bot.size.height / 2 - 50)
        
        [top, bot].forEach {
            $0.zPosition = nextZ()
            scene.addChild($0)
        }
    }
    
    private func addBasketMan() {
        let offset = basketOffset + screenHeightOffset()
        
        basketManMenu = BasketManMenu()
        basketManMenu.position = CGPoint(x: hWidth, y: height - offset)
        basketManMenu.name = ButtonNodes.basketManMenu
        
        scene.addChild(basketManMenu)
    }
    
    private func addLabels() {
        let header = ShopLabel(x: hWidth, y: height - headerOffset, zPosition: nextZ())
        let offset = infoOffset + screenHeightOffset() / 4
        
        infoLabel = InfoLabel(x: hWidth, y: height - offset, zPosition: nextZ())
        
        scene.addChild(header)
        scene.addChild(infoLabel)
    }
    
    private func addButtons() {
        let offset = buttonsOffset + screenHeightOffset() / 2
        
        let buttonGenerator = ButtonGenerator(forScene: scene, yBasePos: height - offset)
        
        buttonGenerator.generate()
        
        purchaseButton = buttonGenerator.purchaseButton
        restoreButton = buttonGenerator.restoreButton
        backButton = buttonGenerator.backButton
    }
}
