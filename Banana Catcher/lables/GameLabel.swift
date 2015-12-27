import SpriteKit

class GameLabel: SKLabelNode {
    
    init(text: String = "") {
       super.init()
        
        self.text = text
        self.fontName = "Georgia Bold"
        self.color = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
