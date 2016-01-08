import Foundation
import SpriteKit

let musicPlayer = MusicPlayer(music: "menu")

let leaderboardID = "grp.banana.catcher"

var didPlayLoadingTransition: Bool = false
var loadingTransitionDuration: Double = 0.6

var score: Int = 0
var highScore: Int = 0
var soundEnabled: Bool = false

var earlierTransactionRestored = false

func random(n: Int, from: Int = 0) -> Int {
    return Int(arc4random_uniform(UInt32(n))) + from
}

func randomBalanced(n: Int, from start: Int = 0) -> Int {
    return random(n, from: start) - n / 2
}
