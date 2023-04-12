//
//  TourRectView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/04/2023.
//

import UIKit

protocol TourRectViewDelegate: AnyObject {
    func TourRectView_onCloseButtonTap(sender: TourRectView)
    func TourRectView_onNextButtonTap(sender: TourRectView)
    func TourRectView_onBackButtonTap(sender: TourRectView)
}

// ---------------------------
class TourRectView: UIView {

    var index: Int = -1
    weak var delegate: TourRectViewDelegate?

    // MARK: - Init(s)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(buildInto container: UIView, index: Int,
        width: CGFloat = 342, height: CGFloat = 150, text: String,
        nextButtonText: String?, backButton backButtonFlag: Bool = true) {
        
        super.init(frame: CGRect.zero)
        self.index = index
        
        self.backgroundColor = UIColor(hex: 0x303B4D)
        self.layer.cornerRadius = 4.0
        container.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
        
            // X axis -----------------------------------
        if(IPHONE()) {
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        } else if(IPAD()) {
            if(index==4 || index==5) {
                self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16).isActive = true
            } else if(index==6) {
                let diff: CGFloat = (400 - width)/2
                self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16-diff).isActive = true
            } else {
                self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            }
        }
        
            // Y axis -----------------------------------
        if(index<4) {
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        } else if(index == 4) {
            let orangeButtonMargin: CGFloat = 64 + 40
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -orangeButtonMargin).isActive = true
        } else if(index == 5) {
            var splitButtonMargin: CGFloat = 210
            if let bottom = SAFE_AREA()?.bottom {
                if(bottom==0) {
                    splitButtonMargin += 10
                } else {
                    splitButtonMargin += bottom
                }
            }
            
            splitButtonMargin += 10
            if(IPAD()) {
                splitButtonMargin += 10
            }
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -splitButtonMargin).isActive = true
        } else if(index == 6) {
            var panelMargin: CGFloat = 275
            if let bottom = SAFE_AREA()?.bottom {
                panelMargin += bottom
            }
            
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -panelMargin).isActive = true
        }

        // LABEL -------------------------------
        let label = UILabel()
        label.textColor = .white
        label.font = ROBOTO(16.5)
        label.numberOfLines = 0
        label.text = text
        label.setLineSpacing(lineSpacing: 4.0)
        self.addSubview(label)
        label.activateConstraints([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        // CLOSE -------------------------------
        let closeIcon = UIImageView(image: UIImage(named: "popup.close.dark"))
        self.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11)
        ])
        
        let closeIconButton = UIButton(type: .custom)
        closeIconButton.backgroundColor = .clear
        self.addSubview(closeIconButton)
        closeIconButton.activateConstraints([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
            
        // BACK LABEL -------------------------------
        var backLabel: UILabel? = nil
        
        if(backButtonFlag) {
            backLabel = UILabel()
            backLabel!.textColor = UIColor(hex: 0xFF643C)
            backLabel!.text = "Back"
            backLabel!.font = ROBOTO(16)
            self.addSubview(backLabel!)
        }
        
        // NEXT BUTTON (ORANGE) -------------------------------
        if let _nextButtonText = nextButtonText {
            let orangeButton = UIButton(type: .custom)
            orangeButton.backgroundColor = UIColor(hex: 0xFF643C)
            orangeButton.layer.cornerRadius = 4.0
            self.addSubview(orangeButton)
            orangeButton.activateConstraints([
                orangeButton.widthAnchor.constraint(equalToConstant: 110),
                orangeButton.heightAnchor.constraint(equalToConstant: 35),
                orangeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                orangeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
            ])
            orangeButton.addTarget(self, action: #selector(onNextButtonTap(_:)), for: .touchUpInside)
            
            let nextLabel = UILabel()
            nextLabel.textColor = .white
            nextLabel.text = _nextButtonText
            nextLabel.font = ROBOTO_BOLD(12.5)
            nextLabel.textAlignment = .center
            self.addSubview(nextLabel)
            nextLabel.activateConstraints([
                nextLabel.widthAnchor.constraint(equalTo: orangeButton.widthAnchor),
                nextLabel.centerXAnchor.constraint(equalTo: orangeButton.centerXAnchor),
                nextLabel.centerYAnchor.constraint(equalTo: orangeButton.centerYAnchor)
            ])
            
            if let _backLabel = backLabel {
                _backLabel.activateConstraints([
                    _backLabel.trailingAnchor.constraint(equalTo: orangeButton.leadingAnchor, constant: -20),
                    _backLabel.centerYAnchor.constraint(equalTo: orangeButton.centerYAnchor)
                ])
            }
        } else {
            if let _backLabel = backLabel {
                _backLabel.activateConstraints([
                    _backLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                    _backLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -23)
                ])
            }
        }

        // BACK BUTTON AREA -------------------------------
        if let _backLabel = backLabel {
            let backButtonArea = UIButton(type: .custom)
            backButtonArea.backgroundColor = .clear
            self.addSubview(backButtonArea)
            backButtonArea.activateConstraints([
                backButtonArea.leadingAnchor.constraint(equalTo: _backLabel.leadingAnchor, constant: -10),
                backButtonArea.trailingAnchor.constraint(equalTo: _backLabel.trailingAnchor, constant: 10),
                backButtonArea.topAnchor.constraint(equalTo: _backLabel.topAnchor, constant: -5),
                backButtonArea.bottomAnchor.constraint(equalTo: _backLabel.bottomAnchor, constant: 5)
            ])
            backButtonArea.addTarget(self, action: #selector(onBackButtonTap(_:)), for: .touchUpInside)
        }
        
        // SPIKE -------------------------------
        if(index>=4) {
            let spike = UIImageView(image: UIImage(named: "tourDialogPoint"))
            self.addSubview(spike)
            spike.activateConstraints([
                spike.widthAnchor.constraint(equalToConstant: 26),
                spike.heightAnchor.constraint(equalToConstant: 26),
                spike.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
            ])
            
            if(index==4) {
                spike.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            } else if(index==5) {
                if(IPHONE()) {
                    spike.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -55).isActive = true
                } else if(IPAD()) {
                    spike.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -70).isActive = true
                }
            } else if(index==6) {
                spike.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            }
            
            self.clipsToBounds = false
        }
    
    }

}

extension TourRectView {
    // MARK: - Event(s)
    @objc func onCloseButtonTap(_ sender: UIButton?) {
        self.delegate?.TourRectView_onCloseButtonTap(sender: self)
    }
    
    @objc func onNextButtonTap(_ sender: UIButton?) {
        self.delegate?.TourRectView_onNextButtonTap(sender: self)
    }
    
    @objc func onBackButtonTap(_ sender: UIButton?) {
        self.delegate?.TourRectView_onBackButtonTap(sender: self)
    }
}
