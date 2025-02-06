import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    /// ✅ Play a sound file from the app bundle
    func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("❌ Could not find \(fileName).mp3 in bundle.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Error playing sound: \(error)")
        }
    }
}
