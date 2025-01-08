//
//  DialogBubbleView_iPad.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/07/2024.
//

import Foundation
import UIKit

class DialogBubbleView_iPad: DialogBubbleView {
    
var selfLeadingConstraint: NSLayoutConstraint? = nil
    var triangleCenterConstraint: NSLayoutConstraint? = nil
    var backButtonTrailingConstraint: NSLayoutConstraint? = nil
    
    let contentLabel = UILabel()
    
    let WIDTH: CGFloat = 343
    
    let prevView = UIView()
    let nextView = UIView()
    
    override func buildInto(container: UIView) {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.layer.cornerRadius = 10.0

        let bottomOffset: CGFloat = CustomNavController.shared.tabsBar.getDim()

        // Tooltip prefs
        let moreInfoIcon = UIImageView(image: UIImage(named: "infoIcon")?.withRenderingMode(.alwaysTemplate))
        moreInfoIcon.tintColor = UIColor(hex: 0x60C4D6)
        self.addSubview(moreInfoIcon)
        moreInfoIcon.activateConstraints([
            moreInfoIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            moreInfoIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
        
        let tipsLabel = UILabel()
        tipsLabel.text = "Tooltip preferences"
        tipsLabel.font = AILERON(14)
        tipsLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x2D2D31)
        self.addSubview(tipsLabel)
        tipsLabel.activateConstraints([
            tipsLabel.leadingAnchor.constraint(equalTo: moreInfoIcon.trailingAnchor, constant: 8),
            tipsLabel.centerYAnchor.constraint(equalTo: moreInfoIcon.centerYAnchor)
        ])
        
        let tipsButton = UIButton(type: .custom)
        tipsButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(tipsButton)
        tipsButton.activateConstraints([
            tipsButton.leadingAnchor.constraint(equalTo: moreInfoIcon.leadingAnchor),
            tipsButton.topAnchor.constraint(equalTo: moreInfoIcon.topAnchor),
            tipsButton.heightAnchor.constraint(equalToConstant: 28),
            tipsButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        tipsButton.addTarget(self, action: #selector(onTipsButtonTap(_:)), for: .touchUpInside)

        // CONTENT
        self.addSubview(self.contentLabel)
        //self.contentLabel.backgroundColor = .green.withAlphaComponent(0.5)
        self.contentLabel.activateConstraints([
            self.contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16-24),
            self.contentLabel.bottomAnchor.constraint(equalTo: moreInfoIcon.topAnchor, constant: -16*2)
        ])
        self.contentLabel.font = ROBOTO(16)
        self.contentLabel.numberOfLines = 0
        self.contentLabel.textColor = CSS.shared.displayMode().main_textColor
        self.contentLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        // DIALOG
        container.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: self.WIDTH),
            self.topAnchor.constraint(equalTo: self.contentLabel.topAnchor, constant: -16),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                constant: -bottomOffset-17-6)
        ])
        self.selfLeadingConstraint = self.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        self.selfLeadingConstraint?.isActive = true

        // TRIANGLE
        self.triangleView.isUserInteractionEnabled = false
        self.triangleView.image = UIImage(named: "triangleDown")?.withRenderingMode(.alwaysTemplate)
        container.addSubview(self.triangleView)
        self.triangleCenterConstraint = self.triangleView.centerXAnchor.constraint(equalTo:
                                                                container.leadingAnchor, constant: 0)
        self.triangleView.backgroundColor = .clear
        self.triangleView.activateConstraints([
            self.triangleView.widthAnchor.constraint(equalToConstant: 36*2),
            self.triangleView.heightAnchor.constraint(equalToConstant: 36),
            self.triangleView.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                                        constant: -bottomOffset-6),
            self.triangleCenterConstraint!
        ])
        self.triangleView.tintColor = self.backgroundColor
        
        // CLOSE
        let closeIcon = UIImageView(image: UIImage(named: "popup.close.dark")?.withRenderingMode(.alwaysTemplate))
        self.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11)
        ])
        closeIcon.tintColor = self.contentLabel.textColor
        
        let closeIconButton = UIButton(type: .custom)
        closeIconButton.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(closeIconButton)
        closeIconButton.activateConstraints([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        // PREV / NEXT
        self.createMoveButton(with: self.nextView, into: self, text: "Next", tag: 1)
        self.nextView.activateConstraints([
            self.nextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        self.createMoveButton(with: self.prevView, into: self, text: "Back", tag: -1)
        self.backButtonTrailingConstraint = self.prevView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
            constant: -16-16-55)
        self.backButtonTrailingConstraint?.isActive = true

        self.gotoStep(1)
    }
    
    func createMoveButton(with view: UIView, into containerView: UIView, text: String, tag: Int) {
        view.backgroundColor = .clear
        containerView.addSubview(view)
        view.activateConstraints([
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            view.widthAnchor.constraint(equalToConstant: 55),
            view.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let label = UILabel()
        label.font = ROBOTO_BOLD(16)
        label.textAlignment = .right
        label.textColor = CSS.shared.cyan
        label.text = text
        view.addSubview(label)
        label.activateConstraints([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        view.addSubview(button)
        button.activateConstraints([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        button.tag = tag
        button.addTarget(self, action: #selector(onMoveButtonTap(_:)), for: .touchUpInside)
    }
    
    override func gotoStep(_ step: Int) {
        self.currentStep = step
        
        var _width = SCREEN_SIZE().width
        if(SCREEN_SIZE().height<_width){ _width = SCREEN_SIZE().height }
        let _W = _width - 150
        let _posX = (SCREEN_SIZE().width - _W)/2
        
        let itemDim: CGFloat = 32
        let itemSep: CGFloat = (_W - (itemDim * 4)) / 3
        let icon_posX = _posX + ((itemDim + itemSep) * (CGFloat(step)-1))
        
        self.triangleCenterConstraint?.constant = icon_posX+18
        
        var dialog_posX = (icon_posX+18)-(self.WIDTH/2)
        if(dialog_posX < 16){ dialog_posX = 16 }
        if((dialog_posX+self.WIDTH) > SCREEN_SIZE().width-16){ dialog_posX = SCREEN_SIZE().width-16-self.WIDTH }
        
        self.selfLeadingConstraint?.constant = dialog_posX
        
        ///////////////////
        if(step==1) {
            self.prevView.hide()
        } else {
            self.prevView.show()
        }
        
        if(step==4) {
            self.backButtonTrailingConstraint?.constant = -16
            self.nextView.hide()
        } else {
            self.backButtonTrailingConstraint?.constant = -16-16-55
            self.nextView.show()
        }
        
        self.contentLabel.text = self.getContent(step)
        
        if(self.firstTime) {
            self.firstTime = false
            CustomNavController.shared.tabsBar.selectTab(step, loadContent: false)
        } else {
            CustomNavController.shared.tabsBar.selectTab(step, loadContent: true)
        }
    }
    
    func gotoStep_2(_ step: Int) {
        self.currentStep = step
        
        let itemDim: CGFloat = 32
        let _W = SCREEN_SIZE().width - (26 * 2.5)
        let itemSep: CGFloat = (_W - (itemDim * 4)) / 3
        let offset = (itemDim * CGFloat(step)) + ((itemSep * CGFloat(step-1))) + (32/2)
        
        self.triangleCenterConstraint?.constant = offset
        
        switch(step) {
            case 1, 2:
                self.selfLeadingConstraint?.constant = 12
         
//            case 2:
//                self.selfLeadingConstraint?.constant = offset - (self.WIDTH/2)
         
            case 3, 4:
                self.selfLeadingConstraint?.constant = SCREEN_SIZE().width - self.WIDTH - 12
         
            default:
                NOTHING()
        }
        
        if(step==1) {
            self.prevView.hide()
        } else {
            self.prevView.show()
        }
        
        if(step==4) {
            self.backButtonTrailingConstraint?.constant = -16
            self.nextView.hide()
        } else {
            self.backButtonTrailingConstraint?.constant = -16-16-55
            self.nextView.show()
        }
        
        self.contentLabel.text = self.getContent(step)
        
        if(self.firstTime) {
            self.firstTime = false
            CustomNavController.shared.tabsBar.selectTab(step, loadContent: false)
        } else {
            CustomNavController.shared.tabsBar.selectTab(step, loadContent: true)
        }
    }
    
    // MARK: Some interaction(s)
    @objc func onTipsButtonTap(_ sender: UIButton) {
        CustomNavController.shared.tour_old?.showPreferencesNotes()
    }
    
    @objc func onCloseButtonTap(_ sender: UIButton?) {
        CustomNavController.shared.tour.cancel()
    }
    
    @objc func onMoveButtonTap(_ sender: UIButton?) {
        let tag = sender!.tag
        let destiny = self.currentStep + tag
        
        self.gotoStep(destiny)
    }
    
}

