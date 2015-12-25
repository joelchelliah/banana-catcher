import UIKit
import SpriteKit

//TODO: move these into a globals file?
let gameFont: String = "Georgia Bold"
let musicPlayer = MusicPlayer(music: "menu")

var score: Int = 0
var soundEnabled: Bool = true

func playSound(node: SKNode, name: String) {
    if soundEnabled {
        node.runAction(SKAction.playSoundFileNamed(name, waitForCompletion: false))
    }
}



class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = MenuScene(size: view.bounds.size)
        let scene = GameOverScene(size: view.bounds.size)
        
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}