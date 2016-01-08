import SpriteKit

struct Textures {
    
    // Menu
    
    static let basketManIdleMenu: SKTexture = SKTexture(imageNamed: "idle_menu")
    static let basketManBlinkMenu: [SKTexture] = Textures.make("blink_menu", 4)
    static let basketManCatchMenu: [SKTexture] = Textures.makeMenuCatch()
    
    static let loading: SKTexture = SKTexture(imageNamed: "loading")
    
    static let title: [SKTexture] = Textures.make("menu_title", 19)
    
    
    // Game
    
    static let bananaNut: SKTexture = SKTexture(imageNamed: "banananut")
    
    static let bananaCluster: SKTexture = SKTexture(imageNamed: "banana_cluster")
    static let bananaClusterSplatIdle: SKTexture = SKTexture(imageNamed: "banana_cluster_splat_1")
    static let bananaClusterSplatBreak: [SKTexture] = Textures.make("banana_cluster_splat", 5)
    
    static let banana: SKTexture = SKTexture(imageNamed: "banana")
    static let bananaSplatIdle: SKTexture = SKTexture(imageNamed: "banana_splat_1")
    static let bananaSplatBreak: [SKTexture] = Textures.make("banana_splat", 5)
    
    static let brokenutIdle: SKTexture = SKTexture(imageNamed: "brokenut_1")
    static let brokenutBreak: [SKTexture] = Textures.make("brokenut", 12)
    
    static let basketManIdle: SKTexture = SKTexture(imageNamed: "idle")
    static let basketManBlink: [SKTexture] = Textures.make("blink", 3)
    static let basketManCatch: [SKTexture] = Textures.make("catch", 10)
    static let basketManOneUp: [SKTexture] = Textures.make("1up", 10)
    static let basketManGreen: [SKTexture] = Textures.make("go_green", 10)
    static let basketManPurple: [SKTexture] = Textures.make("go_purple", 10)
    static let basketManOuch: [SKTexture] = Textures.make("ouch", 10)
    static let basketManSad: [SKTexture] = Textures.make("sad", 8)
    
    static let coconut: SKTexture = SKTexture(imageNamed: "coconut")
    
    static let heart: SKTexture = SKTexture(imageNamed: "heart")
    static let heartNut: SKTexture = SKTexture(imageNamed: "heartnut")
    
    static let monkeyFlying: [SKTexture] = Textures.make("flying", 8)
    static let monkeyAngry: [SKTexture] = Textures.makeAngryMonkey()
    
    static let mushGreen: SKTexture = SKTexture(imageNamed: "greenmush")
    static let mushPurple: SKTexture = SKTexture(imageNamed: "purplemush")
    
    static let ok: SKTexture = SKTexture(imageNamed: "ok")
    
    static let soundOn: SKTexture = SKTexture(imageNamed: "sound_on")
    static let soundOff: SKTexture = SKTexture(imageNamed: "sound_off")
    
    static let superNut: SKTexture = SKTexture(imageNamed: "supernut")
    static let superBrokeIdle: SKTexture = SKTexture(imageNamed: "superbroke_1")
    static let superBrokeBreak: [SKTexture] = Textures.make("superbroke", 12)
    
    
    // Game over
    
    static let scoreboard: [SKTexture] = Textures.make("scoreboard", 8)
    
    static let basketManTears: [SKTexture] = Textures.make("game_over_tears", 5)
    static let basketManSob: [SKTexture] = Textures.make("game_over_sob", 10)
    
    
    // Makers
    
    private static func makeMenuCatch() -> [SKTexture] {
        let all: [SKTexture] = Textures.make("catch_menu", 15)
        
        return all[0...11] + all
    }
    
    private static func makeAngryMonkey() -> [SKTexture] {
        let all: [SKTexture] = Textures.make("monkey_angry", 15)
        let start = Array(all[0...6])
        let mid = Array((1...16).map { _ in all[7...8] }.flatten())
        let end = Array(all[9...14])
        
        return start + mid + end
    }
    
    private static func make(name: String, _ numFrames: Int) -> [SKTexture] {
        return (1...numFrames).map { SKTexture(imageNamed: "\(name)_\($0).png") }
    }
}
