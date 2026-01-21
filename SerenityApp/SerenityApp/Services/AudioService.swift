import AVFoundation
import Foundation

class AudioService {
    static let shared = AudioService()

    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false

    private init() {
        setupAudioSession()
        prepareAudio()
    }

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    private func prepareAudio() {
        guard let url = Bundle.main.url(forResource: "serenity-chime", withExtension: "mp3") else {
            print("Could not find serenity-chime.mp3 in bundle")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 0.7
        } catch {
            print("Failed to load audio file: \(error)")
        }
    }

    func playSerenityTones() {
        guard !isPlaying else { return }

        if audioPlayer == nil {
            prepareAudio()
        }

        guard let player = audioPlayer else {
            print("Audio player not available")
            return
        }

        isPlaying = true
        player.currentTime = 0
        player.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + player.duration) {
            self.isPlaying = false
        }
    }
}
