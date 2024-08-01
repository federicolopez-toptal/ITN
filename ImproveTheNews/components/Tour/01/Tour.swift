//
//  Tour.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/04/2023.
//

import Foundation
import UIKit


class Tour {

    private let TEXTs = [ "",
        "It looks like you're new here.\nWould you like a tour?",
        "On a typical news feed, you lack\ncontrol over what newspapers you're\nshown.",
        "We put YOU in the driver's seat and\nyou choose what you want to be\nshown.",
        "Use the sliders to see different\nperspectives.",
        "Sometimes you want to compare\nboth sides - we call it the 'split'. Go\nahead & check the box!",
        "And we have more sliders to play\nwith - Go ahead & pull up the\npanel to reveal more options."
    ]
    
    private let nextButtonTEXTs: [String?] = [ "",
        "Show me!",
        "Next",
        "Next",
        nil,
        nil,
        nil
    ]
    
    private let backButtonSTATEs = [false,
        false,
        false,
        true,
        true,
        true,
        true
    ]
    
    
    
    
    let totalSteps = 6
    private var rects: [TourRectView]
    let circleAnim = CircleAnimation()

    let buttonForStep4 = UIButton()
    let buttonForStep5 = UIButton()

    var prefNotes: UIView? = nil
    var prefNotesHeightConstraint: NSLayoutConstraint? = nil


    // MARK: - Init(s)
    init(buildInto container: UIView) {
        self.rects = [TourRectView]()
        
        for i in 1...totalSteps {
            var _h: CGFloat = 150
            if(i==4) {
                //_h = 115
                _h = 125
            } else if(i>=5) {
                //_h = 140
                _h = 154
            }
        
            let newRect = TourRectView(buildInto: container, index: i, height: _h,
                text: self.TEXTs[i], nextButtonText: self.nextButtonTEXTs[i],
                backButton: self.backButtonSTATEs[i]
            )
                
            newRect.delegate = self
            newRect.hide()
            self.rects.append(newRect)
        }
        
        // CIRCLE ANIM -----------------------------
        self.circleAnim.buildInto(container)
        self.circleAnim.startAnimation()
        
        // STEP 4 ----------------------------------
        buttonForStep4.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        container.addSubview(buttonForStep4)
        buttonForStep4.activateConstraints([
            buttonForStep4.widthAnchor.constraint(equalToConstant: 64),
            buttonForStep4.heightAnchor.constraint(equalToConstant: 64),
            buttonForStep4.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            buttonForStep4.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0-22)
        ])
        buttonForStep4.addTarget(self, action: #selector(onStep4ButtonTap(_:)), for: .touchUpInside)
        buttonForStep4.hide()
        
        // STEP 5 ----------------------------------
        var splitButtonMargin: CGFloat = 210
        if let bottom = SAFE_AREA()?.bottom {
            if(bottom==0) {
                splitButtonMargin += 10
            } else {
                splitButtonMargin += bottom
            }
        }
        splitButtonMargin -= 55
        if(IPAD()) {
            splitButtonMargin += 15
        }
        
        buttonForStep5.backgroundColor = .clear //.green.withAlphaComponent(0.25)
        container.addSubview(buttonForStep5)
        buttonForStep5.activateConstraints([
            buttonForStep5.widthAnchor.constraint(equalToConstant: 110),
            buttonForStep5.heightAnchor.constraint(equalToConstant: 50),
            buttonForStep5.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            buttonForStep5.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -splitButtonMargin)
        ])
        buttonForStep5.addTarget(self, action: #selector(onStep5ButtonTap(_:)), for: .touchUpInside)
        buttonForStep5.hide()
    }

    func start() {
//        self.showStep(2)
//        
//        CustomNavController.shared.darkView.show()
//        CustomNavController.shared.darkView.alpha = 1

        let popup = TourIntroPopupView()
        popup.pushFromBottom()
    }
    
    func cancel(dissapearDarkBackground: Bool = true) {
        self.hideAllSteps()
        
        if(dissapearDarkBackground) {
            let darkView = CustomNavController.shared.darkView
            UIView.animate(withDuration: 0.2) {
                darkView.alpha = 0.0
            } completion: { _ in
                darkView.hide()
            }
        }
    }
    
    func finish() {
        self.write("10") // never cancelled
        CustomNavController.shared.darkView.hide()
        self.hideAllSteps()
    }

    func hideAllSteps() {
        self.circleAnim.hide()
        self.buttonForStep4.hide()
        self.buttonForStep5.hide()
        
        for v in self.rects {
            v.hide()
        }
        
        //CustomNavController.shared.darkView.hide()
    }

    func showStep(_ num: Int) {
        self.hideAllSteps()

        let rect = self.rects[num-1]
        rect.show()
        
        if(num >= 4) {
            self.circleAnim.show()
            
            if(num==4) {
                self.circleAnim.trailingConstraint?.constant = 17
                self.circleAnim.bottomConstraint?.constant = 10
                self.buttonForStep4.show()
            } else if(num==5) {
                self.circleAnim.trailingConstraint?.constant = -20
                if(IPAD()){ self.circleAnim.trailingConstraint?.constant = -30 }
                self.circleAnim.bottomConstraint?.constant = -148
                
                if let bottom = SAFE_AREA()?.bottom, (bottom == 0) {
                    self.circleAnim.bottomConstraint?.constant += 22
                }
                self.buttonForStep5.show()
            } else if(num==6) {
                if(IPHONE()) {
                    self.circleAnim.trailingConstraint?.constant = -(SCREEN_SIZE().width/2)+64
                } else if(IPAD()) {
                    self.circleAnim.trailingConstraint?.constant = -16-200+64
                }
                
                self.circleAnim.bottomConstraint?.constant = -170
                if let bottom = SAFE_AREA()?.bottom {
                    if(bottom>0) {
                        self.circleAnim.bottomConstraint?.constant -= 25
                    }
                }
                
                CustomNavController.shared.darkView.isUserInteractionEnabled = false
            }
        }
        
        self.write("2" + String(num))
    }
    
    func write(_ value: String) {
        WRITE(LocalKeys.preferences.onBoardingState, value: value)
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
    }
    
    // Event(s)
    @objc func onStep4ButtonTap(_ sender: UIButton?) {
        self.hideAllSteps()
        
        DELAY(0.5) {
            self.showStep(5)
        }
    }
    
    @objc func onStep5ButtonTap(_ sender: UIButton?) {
        self.hideAllSteps()
        
        let tmpButton = UIButton(type: .system)
        tmpButton.tag = 31
        
        DELAY(0.5) {
            self.showStep(6)
        }
    }
    
    
}

extension Tour: TourRectViewDelegate {

    func TourRectView_onCloseButtonTap(sender: TourRectView) {
        self.cancel()
    }
    
    func TourRectView_onNextButtonTap(sender: TourRectView) {
        self.showStep(sender.index+1)
    }
    
    func TourRectView_onBackButtonTap(sender: TourRectView) {
        self.showStep(sender.index-1)
    }
    
    func TourRectView_onTipsButtonTap(sender: TourRectView) {
        self.showPreferencesNotes()
    }
    
}

extension Tour {
    
    private func createPreferencesNotes() {
        self.prefNotes = UIView()
        self.prefNotes?.backgroundColor = .white.withAlphaComponent(0.25)
        
        let containerView = CustomNavController.shared.view!
        containerView.addSubview(self.prefNotes!)
        self.prefNotes?.activateConstraints([
            self.prefNotes!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.prefNotes!.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.prefNotes!.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.prefNotes!.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        var rectWidth: CGFloat = 500
        let availableSpace: CGFloat = SCREEN_SIZE().width - 33
        
        if(availableSpace < rectWidth) {
            rectWidth = availableSpace
        }
        
        let rect = UIView()
        rect.backgroundColor = CSS.shared.displayMode().tour_bgColor
        rect.layer.cornerRadius = 12.0
        self.prefNotes!.addSubview(rect)
        rect.activateConstraints([
            rect.widthAnchor.constraint(equalToConstant: rectWidth),
            rect.centerXAnchor.constraint(equalTo: prefNotes!.centerXAnchor),
            rect.centerYAnchor.constraint(equalTo: prefNotes!.centerYAnchor)
        ])
        self.prefNotesHeightConstraint = rect.heightAnchor.constraint(equalToConstant: 200)
        self.prefNotesHeightConstraint?.isActive = true
        
        let tipsTitle = UILabel()
        tipsTitle.text = "Tip preferences"
        tipsTitle.font = CSS.shared.iPhoneHeader_font
        tipsTitle.textColor = CSS.shared.displayMode().main_textColor
        rect.addSubview(tipsTitle)
        tipsTitle.activateConstraints([
            tipsTitle.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 16),
            tipsTitle.topAnchor.constraint(equalTo: rect.topAnchor, constant: 16)
        ])
        
        let tipsText_text = """
        Keeping our useful tips switched on allows us to demonstrate important functionality and any new features we launch.
        
        You can choose to switch off our useful tips below - if you change your mind you can always switch them back on in the [0]
        """
        
        let tipsText = HyperlinkLabel.parrafo(text: tipsText_text, linkTexts: ["general preferences."],
            urls: ["local://prefs"], onTap: self.onLinkTap(_:))
        rect.addSubview(tipsText)
        tipsText.activateConstraints([
            tipsText.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 16),
            tipsText.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -16),
            tipsText.topAnchor.constraint(equalTo: tipsTitle.bottomAnchor, constant: 16)
        ])
        
        let tipsButton = UIButton(type: .custom)
        tipsButton.backgroundColor = UIColor(hex: 0x60C4D6)
        tipsButton.layer.cornerRadius = 6
        rect.addSubview(tipsButton)
        tipsButton.activateConstraints([
            tipsButton.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 16),
            tipsButton.topAnchor.constraint(equalTo: tipsText.bottomAnchor, constant: 25),
            tipsButton.heightAnchor.constraint(equalToConstant: 40),
            tipsButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        tipsButton.addTarget(self, action: #selector(tipsButtonTap(_:)), for: .touchUpInside)
        
        let tipsButtonLabel = UILabel()
        tipsButtonLabel.text = "Switch off all tooltips"
        tipsButtonLabel.font = AILERON_SEMIBOLD(16)
        tipsButtonLabel.textColor = UIColor(hex: 0x19191C)
        rect.addSubview(tipsButtonLabel)
        tipsButtonLabel.activateConstraints([
            tipsButtonLabel.centerXAnchor.constraint(equalTo: tipsButton.centerXAnchor),
            tipsButtonLabel.centerYAnchor.constraint(equalTo: tipsButton.centerYAnchor)
        ])
        
        
        // CLOSE -------------------------------
        let closeIcon = UIImageView(image: UIImage(named: "popup.close.dark")?.withRenderingMode(.alwaysTemplate))
        rect.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: rect.topAnchor, constant: 16),
            closeIcon.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -16)
        ])
        closeIcon.tintColor = tipsTitle.textColor
        
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
        
        // --------------------------------------------------------------------------------
        // Resize panel
        let _w: CGFloat = rectWidth-16-16
        let H: CGFloat = 16 + tipsTitle.calculateHeightFor(width: _w)
                        + 16 + tipsText.calculateHeightFor(width: _w)
                        + 25 + 40 + 25
                        
        self.prefNotesHeightConstraint?.constant = H
    }
    
    func onLinkTap(_ url: URL) {
        if(url.absoluteString == "local://prefs") {
            for v in CustomNavController.shared.view.subviews {
                if let popup = v as? PopupView {
                    popup.dismissMe()
                }
            }
        
            self.prefNotes?.removeFromSuperview()
            self.prefNotes = nil
            self.cancel()
        
            DELAY(0.5) {
                let vc = PreferencesViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
        }
    }
    
    func showPreferencesNotes() {
        if(self.prefNotes == nil) {
            self.createPreferencesNotes()
        }
        
        if let sView = self.prefNotes?.superview {
            sView.bringSubviewToFront(self.prefNotes!)
        }
        
        self.prefNotes?.show()
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton?) {
        self.prefNotes?.removeFromSuperview()
        self.prefNotes = nil
    }
    
    @objc func tipsButtonTap(_ sender: UIButton?) {
        for v in CustomNavController.shared.view.subviews {
            if let popup = v as? PopupView {
                popup.dismissMe()
            }
        }
        
        self.prefNotes?.hide()
        self.cancel()
    
        WRITE(LocalKeys.preferences.showTips, value: "00")
    }
}
