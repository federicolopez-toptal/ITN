//
//  TourView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/12/2022.
//

import UIKit

class TourView: UIView {
    
    private let TEXTs = [ "",
        "It looks like you're new here.\nWould you like a tour?",
        "On a typical news feed, you lack\ncontrol over what newspapers you're\nshown.",
        "We put YOU in the driver's seat and\nyou choose what you want to be\nshown.",
        "Use the sliders to see different\nperspectives.",
        "Sometimes you want to compare\nboth sides - we call it the 'split'. Go\nahead & check the box!"
    ]
    
    let circleAnim = CircleAnimation()
    
    // MARK: - Init(s)
    init(buildInto container: UIView) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.25)
        //self.isUserInteractionEnabled = false
        container.addSubview(self)
        
        self.activateConstraints([
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        self.circleAnim.buildInto(self)
        DELAY(0.1) {
            self.circleAnim.startAnimation()
        }
        
        self.buildStep1()
        self.buildStep2()
        self.buildStep3()
        self.buildStep4()
        self.buildStep5()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // PRAGMA MARK: - misc
    func hideAllSteps() {
        for v in self.subviews {
            v.hide()
        }
    }
    
    func showStep(_ num: Int) {
        self.hideAllSteps()
        
        if let rect = self.viewWithTag(num) {
            rect.show()
        }
        if let v = self.viewWithTag(20+num) {
            v.show()
        }

        //self.circleAnim.stopAnimation()
        if(num==4) {
            // animation for orange floating button
            self.circleAnim.trailingConstraint?.constant = 17
            self.circleAnim.bottomConstraint?.constant = 10
//            self.circleAnim.startAnimation()
            self.circleAnim.show()
        } else if(num==5) {
            self.circleAnim.trailingConstraint?.constant = -20
            if(IPAD()){ self.circleAnim.trailingConstraint?.constant = -30 }
            self.circleAnim.bottomConstraint?.constant = -148
            
            if let bottom = SAFE_AREA()?.bottom, (bottom == 0) {
                self.circleAnim.bottomConstraint?.constant += 22
            }
            
//            self.circleAnim.startAnimation()
            self.circleAnim.show()
        }

        self.write("2" + String(num))
    }
    
    func start() {
        self.showStep(1)
    }
    
    // MARK: - Data
    func write(_ value: String) {
        WRITE(LocalKeys.preferences.onBoardingState, value: value)
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
    }

}

// MARK: - UI
extension TourView {

    private func createRect(_ index: Int, width: CGFloat, height: CGFloat,
        text: String, orangeButtonText: String? = nil, showBackButton: Bool = false,
        showSpike: Bool = false) {
        
        let rect = UIView()
        rect.backgroundColor = .green //DARK_MODE() ? UIColor(hex: 0x303A4D) : UIColor(hex: 0x19191C)
        
        rect.layer.cornerRadius = 4.0
        rect.tag = 10 + 1
        self.addSubview(rect)
        rect.activateConstraints([
            rect.widthAnchor.constraint(equalToConstant: width),
            rect.heightAnchor.constraint(equalToConstant: height),
            
        ])
        if(IPHONE()) {
            rect.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        } else {
            if(index == 4) {
                rect.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
            } else if(index == 5) {
                rect.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -65).isActive = true
            } else {
                rect.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            }
        }
        
        rect.tag = index
        
        if(index<4) {
            rect.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        } else if(index == 4) {
            let orangeButtonMargin: CGFloat = 64 + 40
            rect.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -orangeButtonMargin).isActive = true
        } else if(index == 5) {
            var splitButtonMargin: CGFloat = 210
            if let bottom = SAFE_AREA()?.bottom {
                if(bottom==0) {
                    splitButtonMargin += 10
                } else {
                    splitButtonMargin += bottom
                }
            }
            
            rect.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -splitButtonMargin).isActive = true
        }
        
        if(showSpike) {
            let spike = UIImageView(image: UIImage(named: "tourDialogPoint"))
            rect.addSubview(spike)
            spike.activateConstraints([
                spike.widthAnchor.constraint(equalToConstant: 26),
                spike.heightAnchor.constraint(equalToConstant: 26),
                spike.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -20),
                spike.bottomAnchor.constraint(equalTo: rect.bottomAnchor, constant: 10)
            ])
        }
        
        let label = UILabel()
        label.textColor = .white
        label.font = ROBOTO(16.5)
        label.numberOfLines = 0
        label.text = text
        label.setLineSpacing(lineSpacing: 4.0)
        rect.addSubview(label)
        label.activateConstraints([
            label.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: rect.topAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -16)
        ])
        
        let closeIcon = UIImageView(image: UIImage(named: "popup.close.dark"))
        rect.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: rect.topAnchor, constant: 11),
            closeIcon.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -11)
        ])
        
        let closeIconButton = UIButton(type: .custom)
        closeIconButton.backgroundColor = .clear
        rect.addSubview(closeIconButton)
        closeIconButton.activateConstraints([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)

    var backLabel: UILabel!
    var backButtonArea: UIButton!
        
        if(showBackButton) {
            backLabel = UILabel()
            backLabel.textColor = UIColor(hex: 0xFF643C)
            backLabel.text = "Back"
            backLabel.font = ROBOTO(16)
            rect.addSubview(backLabel)
        }

        if(orangeButtonText != nil) {
            let orangeButton = UIButton(type: .custom)
            orangeButton.backgroundColor = UIColor(hex: 0xFF643C)
            orangeButton.layer.cornerRadius = 4.0
            rect.addSubview(orangeButton)
            orangeButton.activateConstraints([
                orangeButton.widthAnchor.constraint(equalToConstant: 110),
                orangeButton.heightAnchor.constraint(equalToConstant: 35),
                orangeButton.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -16),
                orangeButton.bottomAnchor.constraint(equalTo: rect.bottomAnchor, constant: -16)
            ])
            orangeButton.tag = 10 + index
            orangeButton.addTarget(self, action: #selector(onOrangeButtonTap(_:)), for: .touchUpInside)
            
            let orangeLabel = UILabel()
            orangeLabel.textColor = .white
            orangeLabel.text = orangeButtonText!
            orangeLabel.font = ROBOTO_BOLD(12.5)
            orangeLabel.textAlignment = .center
            rect.addSubview(orangeLabel)
            orangeLabel.activateConstraints([
                orangeLabel.widthAnchor.constraint(equalTo: orangeButton.widthAnchor),
                orangeLabel.centerXAnchor.constraint(equalTo: orangeButton.centerXAnchor),
                orangeLabel.centerYAnchor.constraint(equalTo: orangeButton.centerYAnchor)
            ])
            
            if(showBackButton) {
                backLabel.activateConstraints([
                    backLabel.trailingAnchor.constraint(equalTo: orangeButton.leadingAnchor, constant: -20),
                    backLabel.centerYAnchor.constraint(equalTo: orangeButton.centerYAnchor)
                ])
            }
        } else {
            if(showBackButton) {
                backLabel.activateConstraints([
                    backLabel.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -20),
                    backLabel.bottomAnchor.constraint(equalTo: rect.bottomAnchor, constant: -23)
                ])
            }
        }
        
        if(showBackButton) {
            backButtonArea = UIButton(type: .custom)
            backButtonArea.backgroundColor = .clear
            rect.addSubview(backButtonArea)
            backButtonArea.activateConstraints([
                backButtonArea.leadingAnchor.constraint(equalTo: backLabel.leadingAnchor, constant: -10),
                backButtonArea.trailingAnchor.constraint(equalTo: backLabel.trailingAnchor, constant: 10),
                backButtonArea.topAnchor.constraint(equalTo: backLabel.topAnchor, constant: -5),
                backButtonArea.bottomAnchor.constraint(equalTo: backLabel.bottomAnchor, constant: 5)
            ])
            backButtonArea.tag = 10 + index
            backButtonArea.addTarget(self, action: #selector(onBackButtonTap(_:)), for: .touchUpInside)
        }
        
        // Button for specific actions in specific steps
        if(index==4) {
            let buttonArea = UIButton(type: .custom)
            buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            self.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.widthAnchor.constraint(equalToConstant: 64),
                buttonArea.heightAnchor.constraint(equalToConstant: 64),
                buttonArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0-22)
            ])
            buttonArea.tag = 20+4
            buttonArea.addTarget(self, action: #selector(onSlidersButtonTap(_:)), for: .touchUpInside)

        } else if(index==5) {
            var splitButtonMargin: CGFloat = 210
            if let bottom = SAFE_AREA()?.bottom {
                if(bottom==0) {
                    splitButtonMargin += 10
                } else {
                    splitButtonMargin += bottom
                }
            }
            //splitButtonMargin -= 55
        
            let buttonArea = UIButton(type: .custom)
            buttonArea.backgroundColor = .clear //.green.withAlphaComponent(0.25)
            self.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.widthAnchor.constraint(equalToConstant: 110),
                buttonArea.heightAnchor.constraint(equalToConstant: 50),
                buttonArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -splitButtonMargin)
            ])
            buttonArea.tag = 20+5
            buttonArea.addTarget(self, action: #selector(onSplitButtonTap(_:)), for: .touchUpInside)
        }
        
        rect.hide()
    }

    func buildStep1() {
        self.createRect(1, width: 342, height: 150, text: self.TEXTs[1],
            orangeButtonText: "SHOW ME!")
    }
    
    func buildStep2() {
        self.createRect(2, width: 342, height: 150, text: self.TEXTs[2],
            orangeButtonText: "NEXT", showBackButton: true)
    }
    
    func buildStep3() {
        self.createRect(3, width: 342, height: 150, text: self.TEXTs[3],
            orangeButtonText: "NEXT", showBackButton: true)
    }
    
    func buildStep4() {
        self.createRect(4, width: 342, height: 120, text: self.TEXTs[4],
            showSpike: true)
    }
    
    func buildStep5() {
        self.createRect(5, width: 342, height: 150, text: self.TEXTs[5],
            showSpike: true)
    }

    func createAnimation() {
        let anim = CircleAnimation()
        anim.buildInto(self)
        
        DELAY(0.3) {
            anim.startAnimation()
        }
    }



}

// MARK: - Events
extension TourView {

    @objc func onCloseButtonTap(_ sender: UIButton?) {
        self.hideAllSteps()
        self.removeFromSuperview()
    }
    
    @objc func onOrangeButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 10
        self.showStep(tag+1)
    }
    
    @objc func onBackButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 10
        self.showStep(tag-1)
        print("BACK")
    }
    
    @objc func onSlidersButtonTap(_ sender: UIButton) {
        self.hideAllSteps()
        CustomNavController.shared.floatingButton.floatingButtonOnTap(nil)
        
        DELAY(0.5) {
            self.showStep(5)
        }
    }
    
    @objc func onSplitButtonTap(_ sender: UIButton) {
        self.onCloseButtonTap(nil)
        self.write("10") // never cancelled
        
        let tmpButton = UIButton(type: .system)
        tmpButton.tag = 31
        CustomNavController.shared.slidersPanel.onSplitButtonTap(tmpButton)
    }

}


