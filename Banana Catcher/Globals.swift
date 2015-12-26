import Foundation
import SpriteKit


let gameFont: String = "Georgia Bold"
let musicPlayer = MusicPlayer(music: "menu")

let leaderboardID = "grp.banana.catcher"

var score: Int = 0
var soundEnabled: Bool = true

func playSound(node: SKNode, name: String) {
    if soundEnabled {
        node.runAction(SKAction.playSoundFileNamed(name, waitForCompletion: false))
    }
}
