import UIKit
import SpriteKit

//TODO: move these into a globals file?
let bgColor = UIColor(red: 102.0/255.0, green: 150.0/255.0, blue: 230.0/255.0, alpha: 1.0)
let gameFont: String = "GillSans-Bold"
var score: Int = 0
var soundEnabled: Bool = true

func playSound(node: SKNode, name: String) {
    if soundEnabled {
        node.runAction(SKAction.playSoundFileNamed(name, waitForCompletion: false))
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
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