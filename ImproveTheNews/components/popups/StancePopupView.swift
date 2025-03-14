//
//  StancePopupView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 18/10/2022.
//

import UIKit

class StancePopupView: PopupView {

    let stanceIcon = StanceIconView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        
        self.height = 390
        if let _bottom = SAFE_AREA()?.bottom, (_bottom == 0) {
            self.height -= 34
        }
        
        let navControllerView = CustomNavController.shared.view!
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: navControllerView.bottomAnchor)
        self.backgroundColor = .systemPink
        
        var W: CGFloat = SCREEN_SIZE().width
        if(IPAD()) {
            W = 550
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        navControllerView.addSubview(self)
        self.activateConstraints([
            self.widthAnchor.constraint(equalToConstant: W),
            self.centerXAnchor.constraint(equalTo: navControllerView.centerXAnchor),
            self.heightAnchor.constraint(equalToConstant: self.height),
            self.bottomConstraint!
        ])
        
        let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("popup.close"))?.withRenderingMode(.alwaysTemplate))
        closeIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        
        self.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 24),
            closeIcon.heightAnchor.constraint(equalToConstant: 24),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        let closeIconButton = UIButton(type: .system)
        closeIconButton.backgroundColor = .clear
        self.addSubview(closeIconButton)
        closeIconButton.activateConstraints([
            closeIconButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeIconButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeIconButton.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: 10),
            closeIconButton.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: 10)
        ])
        closeIconButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        // ------------------
        let titleHStack = HSTACK(into: self, spacing: 7)
        titleHStack.backgroundColor = .clear //.systemPink
        titleHStack.activateConstraints([
            titleHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            titleHStack.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        //titleHStack.addArrangedSubview(self.stanceIcon)
        
        self.titleLabel.font = DM_SERIF_DISPLAY(21)
        //MERRIWEATHER_BOLD(16)
        self.titleLabel.text = "ASDHKJSDH ASJDSAJDLK"
        titleHStack.addArrangedSubview(self.titleLabel)
        ADD_SPACER(to: titleHStack)
        
        // ------------------
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.font = AILERON(16)  //MERRIWEATHER(15)
        self.descriptionLabel.backgroundColor = .clear //.systemPink
        self.descriptionLabel.numberOfLines = 3
        self.descriptionLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        self.descriptionLabel.activateConstraints([
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.descriptionLabel.topAnchor.constraint(equalTo: titleHStack.bottomAnchor, constant: 15)
        ])
        
        // ------------------
        let characterSpacing: Double = 2.5
        let vStack = VSTACK(into: self)
        vStack.backgroundColor = .clear //.yellow
        self.addSubview(vStack)
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 30)
        ])
        
        for i in 1...2 {
            let sliderTitle = UILabel()
            sliderTitle.text = (i==1) ? "POLITICAL STANCE" : "ESTABLISHMENT STANCE"
            sliderTitle.font = AILERON_BOLD(13)
            sliderTitle.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x0A0A0C)
            sliderTitle.addCharacterSpacing(kernValue: characterSpacing)
            vStack.addArrangedSubview(sliderTitle)
            ADD_SPACER(to: vStack, height: 20)
            
            let sliderHStack = HSTACK(into: self)
            sliderHStack.backgroundColor = .clear //.systemPink
            vStack.addArrangedSubview(sliderHStack)
            
            let leftLabel = UILabel()
            leftLabel.text = (i==1) ? "LEFT" : "CRITICAL"
            leftLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x0A0A0C)
            leftLabel.font = AILERON_BOLD(13)
            leftLabel.addCharacterSpacing(kernValue: characterSpacing)
            sliderHStack.addArrangedSubview(leftLabel)
            
            ADD_SPACER(to: sliderHStack)
            
            let rightLabel = UILabel()
            rightLabel.text = (i==1) ? "RIGHT" : "PRO"
            rightLabel.textColor = leftLabel.textColor
            rightLabel.font = AILERON_BOLD(13)
            rightLabel.addCharacterSpacing(kernValue: characterSpacing)
            sliderHStack.addArrangedSubview(rightLabel)
            
            ADD_SPACER(to: vStack, height: 6)
            
            let slider = UISlider()
            slider.minimumValue = 1
            slider.maximumValue = 5
            slider.tag = 20 + i
            vStack.addArrangedSubview(slider)
            slider.isUserInteractionEnabled = false
            
            ADD_SPACER(to: vStack, height: 15)
        }
        
        let moreInfoLabel = UILabel()
        moreInfoLabel.text = "More info"
        moreInfoLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        moreInfoLabel.font = ROBOTO(16)
        moreInfoLabel.backgroundColor = .clear //.black
        self.addSubview(moreInfoLabel)
        moreInfoLabel.activateConstraints([
            moreInfoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            moreInfoLabel.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 16)
        ])
        
        let moreInfoIcon = UIImageView(image: UIImage(named: "infoIcon")?.withRenderingMode(.alwaysTemplate))
//        let moreInfoIcon = UIImageView(image: UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate))
        moreInfoIcon.tintColor = UIColor(hex: 0x60C4D6)
        self.addSubview(moreInfoIcon)
        moreInfoIcon.activateConstraints([
            moreInfoIcon.widthAnchor.constraint(equalToConstant: 20),
            moreInfoIcon.heightAnchor.constraint(equalToConstant: 20),
            moreInfoIcon.trailingAnchor.constraint(equalTo: moreInfoLabel.leadingAnchor, constant: -7),
            moreInfoIcon.centerYAnchor.constraint(equalTo: moreInfoLabel.centerYAnchor)
        ])
        
        let moreInfoButton = UIButton(type: .system)
        moreInfoButton.backgroundColor = .clear //.green.withAlphaComponent(0.25)
        self.addSubview(moreInfoButton)
        moreInfoButton.activateConstraints([
            moreInfoButton.leadingAnchor.constraint(equalTo: moreInfoIcon.leadingAnchor, constant: -5),
            moreInfoButton.trailingAnchor.constraint(equalTo: moreInfoLabel.trailingAnchor, constant: 5),
            moreInfoButton.topAnchor.constraint(equalTo: moreInfoIcon.topAnchor, constant: -5),
            moreInfoButton.bottomAnchor.constraint(equalTo: moreInfoIcon.bottomAnchor, constant: 5),
        ])
        moreInfoButton.addTarget(self, action: #selector(onMoreInfoButtonTap(_:)), for: .touchUpInside)
        
        self.refreshDisplayMode()
        closeIconButton.superview?.bringSubviewToFront(closeIconButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : .white
        self.stanceIcon.refreshDisplayMode()
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.descriptionLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        
//        if(DARK_MODE()) {
//            self.stanceIcon.backgroundColor = UIColor(hex: 0x2A323E)
//        }
        
        // sliders
        for i in 1...2 {
            if let slider = self.viewWithTag(20+i) as? UISlider {
                slider.minimumTrackTintColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xE3E3E3)
                slider.maximumTrackTintColor = slider.minimumTrackTintColor
                slider.setThumbImage(UIImage(named: DisplayMode.imageName("sliderThumb.2")), for: .normal)
                
                let line = UIView()
                line.backgroundColor = .red
                slider.addSubview(line)
                line.activateConstraints([
                    line.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
                    line.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
                    line.heightAnchor.constraint(equalToConstant: 6),
                    line.centerYAnchor.constraint(equalTo: slider.centerYAnchor, constant: 1)
                ])
                line.layer.cornerRadius = 3.5
                line.backgroundColor = slider.minimumTrackTintColor
                line.isUserInteractionEnabled = false
                slider.sendSubviewToBack(line)
            }
        }
    }
    
    func populate(sourceName: String, country: String, LR: Int, PE: Int) {
        self.stanceIcon.setValues(LR, PE)
        self.titleLabel.text = sourceName + " bias"
        self.descriptionLabel.text = sourceName + " is from " + self.country(country) +
            " and has a " + self.LR_text(LR) + " and " + self.PE_text(PE) + " stance"
        self.descriptionLabel.setLineSpacing(lineSpacing: 6)
            
        // sliders
        for i in 1...2 {
            if let slider = self.viewWithTag(20+i) as? UISlider {
                let value = (i==1) ? LR : PE
                slider.setValue(Float(value), animated: false)
            }
        }
        
        if(DARK_MODE()) {
            self.stanceIcon.backgroundColor = UIColor(hex: 0x2A323E)
        }
    }
    
    private func country(_ value: String) -> String {
        switch (value) {
            case "GBR":
                //return "British"
                return "the United Kingdom"
            case "CAN":
                //return "Canadian"
                return "Canada"
            case "LBN":
                //return "Lebanese"
                return "Lebanon"
            case "USA":
                //return "American"
                return "the USA"
            case "ISR":
                //return "Israeli"
                return "Israel"
            case "KOR":
                //return "South Korean"
                return "South Korea"
            case "RUS":
                //return "Russian"
                return "Russia"
            case "CHN":
                //return "Chinese"
                return "China"
            case "QAT":
                //return "Qatari"
                return "Qatar"
                
            default:
                return "Unknown"
        }
    }
    
    private func LR_text(_ value: Int) -> String {
        switch value {
            case 1:
                return "left"
            case 2:
                return "center-left"
            case 3:
                return "center"
            case 4:
                return "center-right"
            default:
                return "right"
        }
    }
    
    private func PE_text(_ value: Int) -> String {
        switch value {
            case 1:
                return "establishment-critical"
            case 2:
                return "slightly establishment-critical"
            case 3:
                return "establishment-neutral"
            case 4:
                return "slightly pro-establishment"
            default:
                return "pro-establishment"
        }
    }
    
    
    // ----------------------------------
    // MARK: - Event(s)
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    @objc func onMoreInfoButtonTap(_ sender: UIButton) {
        //FUTURE_IMPLEMENTATION("Redirect to info regarding sliders")        
        self.dismissMe()
        
        DELAY(0.3) {
            let vc = PreferencesViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
            DELAY(0.3) {
                vc.scrollToSliders()
            }
        }
    }
    
}
