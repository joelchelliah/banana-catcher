import Foundation
import SpriteKit

class GameProps: PropsManager {
    
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
        addEvilMonkey()
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
        let cloudGen = CloudGenerator(forScene: scene)
        let bushGen = BushGenerator(forScene: scene, yBasePos: groundLevel)
        let burriedGen = BurriedGenerator(forScene: scene, yBasePos: groundLevel)
        
        [burriedGen, bushGen, cloudGen].forEach { $0.generate() }
    }
    
    private func addScoreLabel() {
        scoreLabel = ScoreLabel()
        scoreLabel.position = CGPoint(x: 10, y: height - 30)
        
        scene.addChild(scoreLabel)
    }
    
    private func addLives() {
        lives = Lives()
        lives.position = CGPoint(x: width - lives.size.width, y: height - 30)
        
        scene.addChild(lives)
    }
    
    private func addBasketMan() {
        basketMan = BasketMan()
        basketMan.position = CGPoint(x: hWidth, y: groundLevel + 10)
        
        scene.addChild(basketMan)
    }
    
    private func addEvilMonkey() {
        monkey = EvilMonkey()
        monkey.position = CGPoint(x: hWidth, y: height - 130)
        
        scene.addChild(monkey)
    }
}
