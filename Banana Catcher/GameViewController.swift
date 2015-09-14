import UIKit
import SpriteKit

let bgColor = UIColor(red: 0.4, green: 0.5, blue: 0.9, alpha: 1.0)

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MenuScene(size: view.bounds.size)
        
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