import Foundation
import SpriteKit

class TutorialProps: PropsManager {
    
    // Height offsets from top
    private let headerOffset: CGFloat = 50
    private let infoOffset: CGFloat = 90
    private let monkeyOffset: CGFloat = 150
    private let cloudsOffset: CGFloat = 10
    
    init(forScene scene: TutorialScene) {
        super.init(forScene: scene)
    }
    
    override func add() {
        addBackground()
        addGround()
        addDoodads()
        addBasketMan()
        addEvilMonkey()
        addDarkness()
        addLabels()
        addButtons()
    }
    
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPointMake(hWidth, background.size.height / 2)
        background.zPosition = nextZ()
        
        scene.addChild(background)
    }
    
    private func addGround() {
        let ground: Ground = Ground()
        ground.position = CGPoint(x: hWidth, y: ground.size.height / 2)
        
        groundLevel = ground.size.height
        
        scene.addChild(ground)
    }
    
    private func addDoodads() {
        let cOffset = cloudsOffset + screenHeightOffset()
        
        let cloudGen = CloudGenerator(forScene: scene, yBasePos: height - cOffset, fromZPos: nextZ())
        let bushGen = BushGenerator(forScene: scene, yBasePos: groundLevel, fromZPos: nextZ())
        let burriedGen = BurriedGenerator(forScene: scene, yBasePos: groundLevel, fromZPos: nextZ())
        
        [burriedGen, bushGen, cloudGen].forEach { $0.generate() }
        
        advanceZBy(300)
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
        basketMan = BasketMan()
        basketMan.position = CGPoint(x: hWidth, y: groundLevel + 10)
        
        scene.addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        let offset = monkeyOffset + screenHeightOffset()
        
        monkey = EvilMonkey()
        monkey.position = CGPoint(x: hWidth, y: height - offset)
        
        scene.addChild(monkey)
    }
    
    private func addLabels() {
        let header = TutorialLabel(x: hWidth, y: height - headerOffset, zPosition: nextZ())
        let offset = infoOffset + screenHeightOffset() / 4
        
        infoLabel = InfoLabel(x: hWidth, y: height - offset, zPosition: nextZ())
        
        scene.addChild(header)
        scene.addChild(infoLabel)
    }
    
    private func addButtons() {
        let buttonGenerator = ButtonGenerator(forScene: scene, yBasePos: 50, fromZPos: nextZ())
        
        buttonGenerator.generate()
        
        nextButton = buttonGenerator.nextButton
    }
}
