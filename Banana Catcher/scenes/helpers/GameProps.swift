import Foundation
import SpriteKit

class GameProps: PropsManager {
    
    // Height offsets from top
    private let labelOffset: CGFloat = 30
    private let monkeyOffset: CGFloat = 130
    private let levelUpLabelOffset: CGFloat = 200
    private let cloudsOffset: CGFloat = 0
    
    init(forScene scene: GameScene) {
        super.init(forScene: scene)
    }
    
    override func add() {
        addBackground()
        addGround()
        addDoodads()
        addScoreLabel()
        addLives()
        addBasketMan()
        addDarkener()
        addEvilMonkey()
        addLevelUpLabel()
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
    
    private func addLevelUpLabel() {
        let offset = levelUpLabelOffset + screenHeightOffset()
        
        levelUpLabel = LevelUpLabel(x: hWidth, y: height - offset)
        
        scene.addChild(levelUpLabel)
    }
    
    private func addDoodads() {
        let cOffset = cloudsOffset + screenHeightOffset()
        
        let cloudGen = CloudGenerator(forScene: scene, yBasePos: height - cOffset, fromZPos: nextZ())
        let bushGen = BushGenerator(forScene: scene, yBasePos: groundLevel, fromZPos: nextZ())
        let burriedGen = BurriedGenerator(forScene: scene, yBasePos: groundLevel, fromZPos: nextZ())
        
        [burriedGen, bushGen, cloudGen].forEach { $0.generate() }
        
        advanceZBy(600)
    }
    
    private func addDarkener() {
        darkener = SKShapeNode(rect: scene.frame)
        darkener.position = CGPointMake(0, 0)
        darkener.zPosition = nextZ()
        darkener.fillColor = SKColor.blackColor()
        darkener.lineWidth = 0
        darkener.alpha = 0
        
        scene.addChild(darkener)
    }
    
    private func addScoreLabel() {
        let offset = labelOffset + screenHeightOffset() / 8
        
        scoreLabel = ScoreLabel()
        scoreLabel.position = CGPoint(x: 10, y: height - offset)
        scoreLabel.zPosition = nextZ()
        
        scene.addChild(scoreLabel)
    }
    
    private func addLives() {
        let offset = labelOffset + screenHeightOffset() / 8
        
        lives = Lives()
        lives.position = CGPoint(x: width - lives.size.width, y: height - offset)
        lives.zPosition = nextZ()
        
        scene.addChild(lives)
    }
    
    private func addBasketMan() {
        basketMan = BasketMan()
        basketMan.position = CGPoint(x: hWidth, y: groundLevel + 10)
        
        scene.addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        let offset = monkeyOffset + screenHeightOffset() * 0.75
        
        monkey = EvilMonkey()
        monkey.position = CGPoint(x: hWidth, y: height - offset)
        monkey.zPosition = nextZ()
        
        scene.addChild(monkey)
    }
}
