import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = MenuScene(size: view.bounds.size)
        let gameScene = GameOverScene(size: view.bounds.size)
        
        gameScene.scaleMode = .ResizeFill
        
        let gameView = initGameView()
        
        gameView.presentScene(gameScene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    private func initGameView() -> SKView {
        let gameView = view as! SKView
        
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        gameView.ignoresSiblingOrder = true
        
        return gameView
    }
}
