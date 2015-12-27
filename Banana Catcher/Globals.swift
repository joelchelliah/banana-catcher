import Foundation
import SpriteKit

let musicPlayer = MusicPlayer(music: "menu")

let leaderboardID = "grp.banana.catcher"

var score: Int = 0
var soundEnabled: Bool = false

func playSound(node: SKNode, name: String) {
    if soundEnabled {
        node.runAction(SKAction.playSoundFileNamed(name, waitForCompletion: false))
    }
}
