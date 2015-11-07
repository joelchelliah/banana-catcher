import UIKit
import SpriteKit

//TODO: move these into a globals file?
let bgColor = UIColor(red: 102.0/255.0, green: 150.0/255.0, blue: 230.0/255.0, alpha: 1.0)
let gameFont: String = "Chalkduster"
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
        let scene = MenuScene(size: view.bounds.size)
        //let scene = GameOverScene(size: view.bounds.size)
        
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