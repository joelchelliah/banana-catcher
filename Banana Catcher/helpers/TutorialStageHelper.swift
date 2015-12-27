import Foundation
import SpriteKit

class TutorialStageHelper {

    private let scene: TutorialScene
    private let height: CGFloat
    private let width: CGFloat
    private let hWidth: CGFloat
    
    private var currentStage: Int
    private var nextStageReady: Bool
    
    private let finger: SKSpriteNode
    
    init(scene scn: TutorialScene) {
        scene = scn
        height = scene.frame.height
        width = scene.frame.width
        hWidth = width / 2
        
        currentStage = 0
        nextStageReady = true
        
        finger = SKSpriteNode(imageNamed: "finger.png")
        scene.addChild(finger)
        
        playNextStage()
    }
    
    func playNextStage() {
        if !nextStageReady { return }
        
        currentStage += 1
        
        switch currentStage {
            
        case TutorialStages.movement : movementStage()
            
        case TutorialStages.banana : bananaStage()
            
        case TutorialStages.coconut : coconutStage()
            
        default: fatalError("Tutorial stages out of bounds! (\(currentStage))")
        }
    }
    
    
    private func movementStage() {
        initStage()
        
        let positions: [CGFloat] = [-60, 60, 0]
        let movements = positions.map { pos in
            SKAction.runBlock {
                self.fingerMoves(pos)
                self.basketManMoves(pos)
            }
        }
        
        let delayedMovements = zipWithDelays(movements, delay: 1.0)
        
        scene.runAction(SKAction.sequence(
            [changeLabel("Touch the screen to move!"), wait(0.35)]
            + delayedMovements
            + [enableNextStage()]
            ))
    }
    
    private func bananaStage() {
        initStage()
        
        let positions: [CGFloat] = [-100, 100]
        let tosses = positions.map { pos in
            SKAction.runBlock {
                self.monkeyThrows(Banana(), throwForceX: pos / 50)
                self.fingerMoves(pos)
                self.basketManMoves(pos)
            }
        }
        
        let delayedTosses = zipWithDelays(tosses, delay: 1.5)
        
        scene.runAction(SKAction.sequence(
            [changeLabel("Catch all the bananas!"), wait(0.35)]
            + delayedTosses
            + [enableNextStage()]
            ))
    }
    
    private func coconutStage() {
        initStage()
        
        let positions: [CGFloat] = [-90, 90]
        let tosses = positions.map { pos in
            SKAction.runBlock {
                self.monkeyThrows(Coconut(), throwForceX: -pos / 25)
                self.fingerMoves(pos)
                self.basketManMoves(pos)
            }
        }
        
        let delayedTosses = zipWithDelays(tosses, delay: 1.4)
        
        scene.runAction(SKAction.sequence(
            [changeLabel("Avoid the coconuts!"), wait(0.35)]
                + delayedTosses
                + [enableNextStage()]
            ))
    }
    
    private func fingerMoves(x: CGFloat) {
        let wait = SKAction.waitForDuration(0.2)
        let move = SKAction.moveToX(hWidth + x, duration: 0.3)
        
        finger.runAction(SKAction.sequence([wait, move]))
    }
    
    private func basketManMoves(x: CGFloat) {
        scene.basketManMoves(x)
    }
    
    private func monkeyThrows(item: Throwable, throwForceX force: CGFloat) {
        scene.monkeyThrows(item, throwForceX: force)
    }
    
    private func initStage() {
        let isLastStage = TutorialStages.lastStage(currentStage)
        
        nextStageReady = false
        finger.alpha = 0
        finger.position = CGPointMake(hWidth, 100)
        finger.runAction(SKAction.fadeInWithDuration(1.0))
        
        scene.prepareForNextStage(isLastStage)
    }

    
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // * Actions
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func enableNextStage() -> SKAction {
        return SKAction.runBlock {
            self.scene.enableNextButton()
            self.nextStageReady = true
            self.finger.runAction(SKAction.fadeOutWithDuration(1.0))
        }
    }
    
    private func changeLabel(text: String) -> SKAction {
        return SKAction.runBlock { self.scene.changeInfoLabelText(text) }
    }
    
    private func zipWithDelays(actions: [SKAction], delay: NSTimeInterval) -> [SKAction] {
        let delays = (1...actions.count).map { _ in wait(delay) }
        
        return zip(actions, delays).flatMap { [$0, $1] }
    }
    
    private func wait(duration: NSTimeInterval) -> SKAction {
        return SKAction.waitForDuration(duration)
    }
}
