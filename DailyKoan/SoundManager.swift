import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    /**
     Plays a sound file from the app bundle at 50% volume.
     
     This method searches for the sound file with the given name (and "mp3" extension),
     sets the volume to 0.5, prepares the player, and then plays the sound.
     
     - Parameter fileName: The name of the sound file (without extension).
     */
    func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("❌ Could not find \(fileName).mp3 in bundle.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.5  // Reduce volume to 50%
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Error playing sound: \(error)")
        }
    }
}
