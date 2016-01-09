import Foundation
import SpriteKit

class GameOverProps: PropsManager {
    
    // Height offsets from top
    private let labelOffset: CGFloat = 50
    private let scoreBoardOffset: CGFloat = 160
    private let buttonsOffset: CGFloat = 295
    private let groundOffset: CGFloat = 440
    private let botDarkOffset: CGFloat = 510
    
    init(forScene scene: GameOverScene) {
        super.init(forScene: scene)
    }
    
    override func add() {
        addBackground()
        addGround()
        addDarkness()
        addLabel()
        addScoreBoard()
        addButtons()
    }
    
    private func addBackground() {
        let sky = SKSpriteNode(imageNamed: "menu_sky.png")
        sky.position = CGPointMake(hWidth, sky.size.height / 2)
        
        let rain = Emitters.rain
        rain.position = CGPointMake(hWidth, height + 50)
        
        [sky, rain].forEach {
            $0.zPosition = nextZ()
            
            scene.addChild($0)
        }
    }
    
    private func addGround() {
        let offset = groundOffset + screenHeightOffset()
        
        let tearsTex = Textures.basketManTears
        let sobTex = Textures.basketManSob
        let ground = SKSpriteNode(texture: tearsTex.first)
        
        let tears = SKAction.animateWithTextures(tearsTex, timePerFrame: 0.08)
        let cry = SKAction.repeatAction(tears, count: 5)
        let sob = SKAction.animateWithTextures(sobTex, timePerFrame: 0.08)
        
        ground.position = CGPointMake(hWidth, height - offset)
        ground.zPosition = nextZ()
        ground.name = ButtonNodes.basketManMenu
        ground.runAction(SKAction.repeatActionForever(SKAction.sequence([cry, sob])))
        
        scene.addChild(ground)
        
        groundLevel = height - offset + 70
    }
    
    private func addDarkness() {
        let offset = botDarkOffset + screenHeightOffset()
        
        let top = SKSpriteNode(imageNamed: "darkness_top.png")
        let bot = SKSpriteNode(imageNamed: "darkness_bottom.png")
        
        top.size.height *= 0.75
        
        top.position = CGPointMake(hWidth, height - top.size.height / 2)
        bot.position = CGPointMake(hWidth, height - offset)
        
        [top, bot].forEach {
            $0.zPosition = nextZ()
            
            scene.addChild($0)
        }
    }
    
    private func addLabel() {
        let label = GameOverLabel(x: hWidth, y: height - labelOffset, zPosition: nextZ())
        
        scene.addChild(label)
    }
    
    private func addScoreBoard() {
        let offset = scoreBoardOffset + screenHeightOffset() / 4
        
        let yPos = height - offset
        let textures = Textures.scoreboard
        let scoreBoard = SKSpriteNode(texture: textures.first)
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.08)
        
        scoreBoard.position = CGPointMake(hWidth, yPos)
        scoreBoard.zPosition = nextZ()
        scoreBoard.runAction(SKAction.repeatActionForever(animation))
        
        scene.addChild(scoreBoard)
        
        let label1 = ScoreboardLabel(name: "Score:", size: 23, x: hWidth, y: yPos)
        let label2 = ScoreboardLabel(name: score.description, size: 18, x: hWidth, y: yPos - 20)
        let label3 = ScoreboardLabel(name: "High Score:", size: 23, x: hWidth, y: yPos - 55)
        let label4 = ScoreboardLabel(name: highScore.description, size: 18, x: hWidth, y: yPos - 75)
        
        [label1, label2, label3, label4].forEach {
            $0.zPosition = nextZ()
            
            scene.addChild($0)
        }
    }
    
    private func addButtons() {
        let offset = buttonsOffset + screenHeightOffset() / 2
        let buttonGenerator = ButtonGenerator(forScene: scene, yBasePos: height - offset)
        
        buttonGenerator.generate()
    }
}
