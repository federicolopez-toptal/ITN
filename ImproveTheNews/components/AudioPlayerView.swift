//
//  AudioPlayerView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 08/06/2023.
//

import Foundation
import UIKit


class AudioPlayerView: UIView {
    
    var mainHStack_heightConstraint: NSLayoutConstraint!
    private let heightClosed: CGFloat = 50
    private let heightOpened: CGFloat = 200
    
    private var isOpen = false
    private var wasBuilt = false
    
    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ containerVStack: UIStackView, file: AudioFile) {
        if(self.wasBuilt) { return }
    
        let mainHStack = HSTACK(into: containerVStack)
        //mainHStack.backgroundColor = .yellow
        
        self.isOpen = false
        self.mainHStack_heightConstraint = mainHStack.heightAnchor.constraint(equalToConstant: self.heightClosed)
        self.mainHStack_heightConstraint.isActive = true

        ADD_SPACER(to: mainHStack, width: 13)
        
        let colorRect = UIView()
        colorRect.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D2530) : UIColor(hex: 0xEAEBEC)
        mainHStack.addArrangedSubview(colorRect)
        
        ADD_SPACER(to: mainHStack, width: 13)
        
        // -------
        let colorLine = UIView()
        colorLine.backgroundColor = UIColor(hex: 0xF3643C)
        colorRect.addSubview(colorLine)
        colorLine.activateConstraints([
            colorLine.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            colorLine.topAnchor.constraint(equalTo: colorRect.topAnchor),
            colorLine.bottomAnchor.constraint(equalTo: colorRect.bottomAnchor),
            colorLine.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        let listenLabel = UILabel()
        listenLabel.font = MERRIWEATHER_BOLD(16)
        listenLabel.text = "Listen to this story"
        listenLabel.textColor = DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)
        colorRect.addSubview(listenLabel)
        listenLabel.activateConstraints([
            listenLabel.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor, constant: 16),
            listenLabel.topAnchor.constraint(equalTo: colorRect.topAnchor, constant: 16)
        ])
        
        let buttonArea = UIButton(type: .custom)
        //buttonArea.backgroundColor = .red.withAlphaComponent(0.25)
        colorRect.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: colorRect.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: colorRect.trailingAnchor),
            buttonArea.topAnchor.constraint(equalTo: colorRect.topAnchor),
            buttonArea.heightAnchor.constraint(equalToConstant: 50)
        ])
        buttonArea.addTarget(self, action: #selector(buttonAreaOnTap(_:)), for: .touchUpInside)
        
        ADD_SPACER(to: containerVStack, height: 5)
        self.wasBuilt = true
    }
    
    // MARK: - Event(s)
    @objc func buttonAreaOnTap(_ sender: UIButton?) {
        print("change!")
        self.isOpen = !self.isOpen
        
        if(self.isOpen) {
            self.mainHStack_heightConstraint.constant = self.heightOpened
        } else {
            self.mainHStack_heightConstraint.constant = self.heightClosed
        }
    }
}


// MARK: - Custom type
struct AudioFile {
    var file: String = ""
    var duration: Int = 0
    var created: String = ""
    
    init(file: String, duration: Int, created: String) {
        self.file = file
        self.duration = duration
        self.created = created
    }
}
