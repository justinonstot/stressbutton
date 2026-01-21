import AVFoundation
import Foundation

class AudioService: ObservableObject {
    static let shared = AudioService()

    private var audioEngine: AVAudioEngine?
    private var tonePlayer: AVAudioPlayerNode?
    private var isPlaying = false

    private init() {
        setupAudioSession()
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

    func playSerenityTones() {
        guard !isPlaying else { return }
        isPlaying = true

        Task {
            await playToneSequence()
            isPlaying = false
        }
    }

    private func playToneSequence() async {
        let frequencies: [(frequency: Double, duration: Double)] = [
            (396.0, 0.4),   // G4 - Liberation frequency
            (528.0, 0.4),   // C5 - Love/healing frequency
            (639.0, 0.5),   // E5 - Connection frequency
            (741.0, 0.6),   // F#5 - Awakening frequency
        ]

        for tone in frequencies {
            await playTone(frequency: tone.frequency, duration: tone.duration)
            try? await Task.sleep(nanoseconds: 50_000_000) // 50ms gap between tones
        }
    }

    private func playTone(frequency: Double, duration: Double) async {
        let sampleRate: Double = 44100.0
        let amplitude: Float = 0.3
        let frameCount = Int(duration * sampleRate)

        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(frameCount)) else {
            return
        }

        buffer.frameLength = AVAudioFrameCount(frameCount)
        let data = buffer.floatChannelData![0]

        // Generate sine wave with envelope for smooth start/end
        let attackFrames = Int(0.05 * sampleRate)
        let releaseFrames = Int(0.1 * sampleRate)

        for frame in 0..<frameCount {
            let time = Double(frame) / sampleRate
            var envelope: Float = 1.0

            // Attack envelope
            if frame < attackFrames {
                envelope = Float(frame) / Float(attackFrames)
            }
            // Release envelope
            else if frame > frameCount - releaseFrames {
                envelope = Float(frameCount - frame) / Float(releaseFrames)
            }

            // Sine wave with slight harmonics for richer sound
            let fundamental = sin(2.0 * .pi * frequency * time)
            let harmonic2 = sin(2.0 * .pi * frequency * 2.0 * time) * 0.15
            let harmonic3 = sin(2.0 * .pi * frequency * 3.0 * time) * 0.05

            data[frame] = amplitude * envelope * Float(fundamental + harmonic2 + harmonic3)
        }

        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()

        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: audioFormat)

        do {
            try engine.start()
            player.scheduleBuffer(buffer, completionHandler: nil)
            player.play()

            try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))

            player.stop()
            engine.stop()
        } catch {
            print("Audio playback error: \(error)")
        }
    }
}
