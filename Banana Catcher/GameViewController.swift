import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController {
    
    var gcEnabled = Bool()              // Stores if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Stores the default leaderboardID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.authenticateLocalPlayer()
        
        let gameScene = MenuScene(size: view.bounds.size)
        //let gameScene = GameOverScene(size: view.bounds.size)
        //let gameScene = TutorialScene(size: view.bounds.size)
        //let gameScene = GameScene(size: view.bounds.size)
        
        gameScene.scaleMode = .ResizeFill
        
        let gameView = initGameView()
        
        gameView.presentScene(gameScene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if((viewController) != nil) {
                // 1 Show login if player is not logged in
                self.presentViewController(viewController!, animated: true, completion: nil)
                
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
        }
    }
    
    
    private func initGameView() -> SKView {
        let gameView = view as! SKView
        
        gameView.showsFPS = false
        gameView.showsNodeCount = false
        gameView.ignoresSiblingOrder = true
        
        return gameView
    }
}
