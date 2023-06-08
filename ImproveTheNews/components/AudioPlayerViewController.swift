//
//  AudioPlayerViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/06/2023.
//

import UIKit

class AudioPlayerViewController: BaseViewController {

    let player = AudioPlayerView()
    var VStack: UIStackView!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.buildContent()
    }

    private func buildContent() {
        self.view.backgroundColor = .darkGray
        
        self.VStack = VSTACK(into: self.view)
        //self.VStack.backgroundColor = .green
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.VStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.VStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200)
        ])
        
        let aUrl = "https://itnaudio.s3.us-east-2.amazonaws.com/split_audio/ITNPod07JUN2023_8176.mp3"
        let audioFile = AudioFile(file: aUrl, duration: 194, created: "Jun 06 23")
        self.player.buildInto(self.VStack, file: audioFile)
    }

}
