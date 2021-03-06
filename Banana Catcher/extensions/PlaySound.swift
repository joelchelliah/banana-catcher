import Foundation
import SpriteKit

struct Sounds {
    static let angry: String = "monkey_angry"
    static let caught: String = "caught"
    static let dead: String = "dead"
    static let ouch: String = "ouch"
    static let one_up: String = "one_up"
    static let select: String = "option_select"
    static let smash: String = "smash"
    static let supernut: String = "supernut"
    static let supersmash: String = "supersmash"
    static let splat: String = "splat"
    static let shroom: String = "shroom"
    static let clusterSplat: String = "cluster_splat"
    static let toss: String = "toss"
    static let specialToss: String = "special_toss"
}

extension SKNode {
    func playSound(name: String) {
        if soundEnabled {
            let num = numVariations(name)
            let fileName = num > 1 ? "\(name)_\(random(num, from: 1))" : name
            
            self.runAction(SKAction.playSoundFileNamed("\(fileName).wav", waitForCompletion: false))
        }
    }
    
    private func numVariations(name: String) -> Int {
        let variations = [
            Sounds.angry: 4,
            Sounds.caught: 3,
            Sounds.ouch: 3,
            Sounds.select: 2,
            Sounds.shroom: 2,
            Sounds.smash: 3,
            Sounds.splat: 3,
            Sounds.supernut: 3,
            Sounds.toss: 3
        ]
        
        if let num = variations[name] {
            return num
        } else {
            return 1
        }
    }
}
