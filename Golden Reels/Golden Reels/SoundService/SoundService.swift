import AVFoundation

enum Music: String {
    case background = "background music"
}

enum Sounds: String {
    case click = "click sound"
    case spin = "spin slot sound"
    case win = "win sound"
}

final class SoundService {
    
    static let shared = SoundService()
    
    var isMusicEnabled: Bool {
        return UserDefaults.isMusicEnabled
    }
    
    var isSoundsEnabled: Bool {
        return UserDefaults.isSoundsEnabled
    }
    
    private var musicPlayer: AVAudioPlayer?
    private var soundPlayer: AVAudioPlayer?
    
    private init() { }
    
    // Music
    
    func playMusic() {
        guard isMusicEnabled else { return }
        
        if let soundURL = Bundle.main.url(forResource: Music.background.rawValue, withExtension: "mp3") {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                self.musicPlayer = nil
                self.musicPlayer = audioPlayer
                audioPlayer.numberOfLoops = -1
                audioPlayer.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        } else {
            print("Sound file not found: \(Music.background.rawValue).mp3")
        }
    }
    
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    // Sounds
    
    func playSound(named soundName: Sounds) {
        guard isSoundsEnabled else { return }
        
        if let soundURL = Bundle.main.url(forResource: soundName.rawValue, withExtension: "mp3") {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                self.soundPlayer = audioPlayer
                audioPlayer.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        } else {
            print("Sound file not found: \(soundName.rawValue).mp3")
        }
    }
}
