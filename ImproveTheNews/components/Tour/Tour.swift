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


    // MARK: - Init(s)
    init(buildInto container: UIView) {
        self.rects = [TourRectView]()
        
        for i in 1...totalSteps {
            var _h: CGFloat = 150
            if(i==4) {
                _h = 115
            } else if(i>=5) {
                _h = 140
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
    
    func cancel() {
        self.hideAllSteps()
        
        let darkView = CustomNavController.shared.darkView
        UIView.animate(withDuration: 0.2) {
            darkView.alpha = 0.0
        } completion: { _ in
            darkView.hide()
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
        CustomNavController.shared.floatingButton.floatingButtonOnTap(nil)
        
        DELAY(0.5) {
            self.showStep(5)
        }
    }
    
    @objc func onStep5ButtonTap(_ sender: UIButton?) {
        self.hideAllSteps()
        
        let tmpButton = UIButton(type: .system)
        tmpButton.tag = 31
        CustomNavController.shared.slidersPanel.onSplitButtonTap(tmpButton)
        
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
        if(sender.index==5) {
            CustomNavController.shared.slidersPanel.show(rows: 0)
        } else if(sender.index==6) {
            CustomNavController.shared.slidersPanel.forceSplitOff()
            NOTIFY(Notification_reloadMainFeed)
        }
        
        self.showStep(sender.index-1)
    }
    
}
