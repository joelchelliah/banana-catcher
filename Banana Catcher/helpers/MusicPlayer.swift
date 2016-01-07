import Foundation
import AVFoundation

class MusicPlayer {
    
    var player = AVAudioPlayer()
    var isPlaying = false
    
    init(music: String) {
        
        change(music)
    }
    
    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func change(music: String) {
        let path = NSBundle.mainBundle().URLForResource(music, withExtension: "mp3")
        
        do {
            try player = AVAudioPlayer(contentsOfURL: path!)
            player.numberOfLoops = -1
        } catch {
            print("Could not init player!")
        }
        
        play()
    }
    
    private func play() {
        if soundEnabled {
            player.play()
            isPlaying = true
        }
    }
    
    private func pause() {
        player.pause()
        isPlaying = false
    }
}