//
//  AudioView.swift
//  TestApp
//
//  Created by 伊藤陸斗 on 2023/12/26.
//

import SwiftUI

import AVFoundation

struct AudioPlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var remoteAudioPlayer: AVPlayer?
    let audioURL: URL = URL(string: "https://example.com/your-audio-file.wav")!

    var body: some View {
        VStack {
            Button("Play") {
                playAudio()
            }
        }
        .onAppear {
            setupRemoteAudioPlayer()
        }
    }

    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "your-audio-file", withExtension: "wav") else {
            print("Audio file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    private func setupRemoteAudioPlayer() {
        let playerItem = AVPlayerItem(url: audioURL)
        remoteAudioPlayer = AVPlayer(playerItem: playerItem)
    }

    private func playAudio() {
        remoteAudioPlayer?.play()
    }
}

#Preview {
    AudioPlayerView()
}
