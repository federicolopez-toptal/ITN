//
//  SlidersPanel_misc.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 16/07/2024.
//

import UIKit

extension SlidersPanel {
    
    func addContent() {
        self.rowsVStack = VSTACK(into: self.contentView, spacing: self.rowSep)
        self.rowsVStack.backgroundColor = self.backgroundColor
        self.rowsVStack.activateConstraints([
            self.rowsVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.rowsVStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -25),
            self.rowsVStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.rowsVStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        ])

        for i in 0...5 {
            self.addRow(i)
        }
        
        ADD_SPACER(to: self.rowsVStack, backgroundColor: .red, height: 100)
        
    }
    
    func addRow(_ index: Int) {
        let rowView = UIView()
//        rowView.backgroundColor = .orange.withAlphaComponent(0.25)
        rowView.backgroundColor = self.backgroundColor
        self.rowsVStack.addArrangedSubview(rowView)
        rowView.activateConstraints([
            rowView.heightAnchor.constraint(equalToConstant: self.rowHeight)
        ])
        
        let rowTitleLabel = UILabel()
        rowTitleLabel.text = self.titles[index].uppercased()
        rowTitleLabel.font = AILERON_BOLD(13)
        rowTitleLabel.textColor = CSS.shared.displayMode().main_textColor
        rowTitleLabel.addCharacterSpacing(kernValue: 1.5)
        rowView.addSubview(rowTitleLabel)
        rowTitleLabel.activateConstraints([
            rowTitleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            rowTitleLabel.topAnchor.constraint(equalTo: rowView.topAnchor)
        ])
        
        if(index < 2) { // SPLIT(s)
            let splitLabel = UILabel()
            splitLabel.text = "SPLIT"
            splitLabel.textAlignment = .right
            splitLabel.font = AILERON_BOLD(13)
            splitLabel.textColor = CSS.shared.displayMode().main_textColor
            splitLabel.addCharacterSpacing(kernValue: 1.5)
            rowView.addSubview(splitLabel)
            splitLabel.activateConstraints([
                splitLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: 0),
                splitLabel.topAnchor.constraint(equalTo: rowView.topAnchor, constant: 0)
            ])
            
            let square = UIImageView(image: UIImage(named: "slidersPanel.split.square"))
            rowView.addSubview(square)
            square.activateConstraints([
                square.widthAnchor.constraint(equalToConstant: 15),
                square.heightAnchor.constraint(equalToConstant: 15),
                square.trailingAnchor.constraint(equalTo: splitLabel.leadingAnchor, constant: -10),
                square.topAnchor.constraint(equalTo: rowView.topAnchor)
            ])
            
            let check = UIImageView(image: UIImage(named: "slidersPanel.split.check"))
            rowView.addSubview(check)
            check.activateConstraints([
                check.widthAnchor.constraint(equalToConstant: 18),
                check.heightAnchor.constraint(equalToConstant: 14),
                check.leadingAnchor.constraint(equalTo: square.leadingAnchor, constant: 3),
                check.topAnchor.constraint(equalTo: rowView.topAnchor, constant: -3)
            ])
            check.tag = 40 + index + 1
            check.hide()
            
            let checkButton = UIButton(type: .system)
            checkButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
            rowView.addSubview(checkButton)
            checkButton.activateConstraints([
                checkButton.topAnchor.constraint(equalTo: square.topAnchor, constant: -10),
                checkButton.bottomAnchor.constraint(equalTo: square.bottomAnchor, constant: 10),
                checkButton.leadingAnchor.constraint(equalTo: square.leadingAnchor, constant: -10),
                checkButton.trailingAnchor.constraint(equalTo: splitLabel.trailingAnchor, constant: 10),
            ])
            checkButton.tag = 30 + index
            checkButton.addTarget(self, action: #selector(onSplitButtonTap(_:)), for: .touchUpInside)
            
            let grayCircle = UIView()
            grayCircle.backgroundColor = UIColor(hex: 0xbbbdc0)
            rowView.addSubview(grayCircle)
            grayCircle.activateConstraints([
                grayCircle.widthAnchor.constraint(equalToConstant: 17),
                grayCircle.heightAnchor.constraint(equalToConstant: 17),
                grayCircle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 2)
            ])
            grayCircle.layer.cornerRadius = 16/2
            grayCircle.tag = 50 + index + 1
            grayCircle.hide()
        }
        
        let L = self.legends[index]
        let leftLabel = UILabel()
        leftLabel.text = L.0.uppercased()
        leftLabel.font = AILERON_BOLD(13)
        leftLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        leftLabel.addCharacterSpacing(kernValue: 1.5)
        rowView.addSubview(leftLabel)
        leftLabel.activateConstraints([
            leftLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            leftLabel.topAnchor.constraint(equalTo: rowTitleLabel.bottomAnchor, constant: 12)
        ])

        let rightLabel = UILabel()
        rightLabel.textAlignment = .right
        rightLabel.text = L.1.uppercased()
        rightLabel.font = AILERON_BOLD(13)
        rightLabel.textColor = leftLabel.textColor
        rightLabel.addCharacterSpacing(kernValue: 1.5)
        rowView.addSubview(rightLabel)
        rightLabel.activateConstraints([
            rightLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            rightLabel.topAnchor.constraint(equalTo: rowTitleLabel.bottomAnchor, constant: 16)
        ])
        
        var sliderValue = LocalKeys.sliders.defaultValues[index]
        if let _value = READ(LocalKeys.sliders.allKeys[index]) {
            sliderValue = Int(_value)!
        }
        
        let sliderLineColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
        let slider = UISlider()
        slider.backgroundColor = .clear //self.backgroundColor
        slider.minimumValue = 0
        slider.maximumValue = 99
        slider.isContinuous = false
        slider.minimumTrackTintColor = sliderLineColor
        slider.maximumTrackTintColor = sliderLineColor
        
        let thumbImg = UIImage(named: "slidersOrangeThumb")
        slider.setThumbImage(thumbImg, for: .normal)
        
        rowView.addSubview(slider)
        slider.activateConstraints([
            slider.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            slider.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 12)
        ])
        
        slider.tag = 20 + index
        slider.setValue(Float(sliderValue), animated: false)
        slider.addTarget(self, action: #selector(sliderOnValueChange(_:)), for: .valueChanged)
        
        if let _grayCircle = rowView.viewWithTag(50+index+1) {
            _grayCircle.activateConstraints([
                _grayCircle.centerYAnchor.constraint(equalTo: slider.centerYAnchor)
            ])
        }
        
        rowView.hide()
    }
    
    @objc func sliderOnValueChange(_ sender: UISlider) {
        let tag = sender.tag - 20
        let newValue = Int(round(sender.value))
        let strValue = String(format: "%02d", newValue)
        let key = LocalKeys.sliders.allKeys[tag]
        
        WRITE(key, value: strValue)
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        NOTIFY(Notification_reloadMainFeed)
    }
    
    @objc func onSplitButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 30 + 1

        if(self.split == tag) {
            self.split = 0
        } else {
            self.split = tag
        }
        
        self.checkSplitComponents()
        WRITE(LocalKeys.sliders.split, value: String(self.split))
        
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        NOTIFY(Notification_reloadMainFeed)
    }
    
    func checkSplitComponents() {
        for i in 1...2 {
            // update check
            if(i==self.split) {
                self.viewWithTag(40+i)?.show()
            } else {
                self.viewWithTag(40+i)?.hide()
            }

            // update slider thumb
            var imageAlpha = 1.0
            let slider = self.viewWithTag(20 + i - 1) as! UISlider
            let grayCircle = self.viewWithTag(50 + i)!

            if(i==self.split) {
                imageAlpha = 0.0
                slider.isUserInteractionEnabled = false
                grayCircle.superview!.bringSubviewToFront(grayCircle)
                grayCircle.show()
            } else {
                slider.isUserInteractionEnabled = true
                grayCircle.hide()
            }

            let alphaImage = UIImage(named: "slidersOrangeThumb")?.image(alpha: imageAlpha)
            slider.setThumbImage(alphaImage, for: .normal)
        }
    }
    
    func addMoreButton() {
        self.refreshButton.backgroundColor = CSS.shared.cyan
        self.refreshButton.layer.cornerRadius = 5.0
        self.addSubview(self.refreshButton)
        self.refreshButton.activateConstraints([
            self.refreshButton.widthAnchor.constraint(equalToConstant: 40),
            self.refreshButton.heightAnchor.constraint(equalToConstant: 40),
            self.refreshButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.margin),
            self.refreshButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                constant: IPHONE() ? -self.margin : -self.margin-80 )
        ])
        self.refreshButton.addTarget(self, action: #selector(refreshButtonOnTap(_:)), for: .touchUpInside)
        
        let refreshIcon = UIImageView(image: UIImage(named: "refresh"))
        self.refreshButton.addSubview(refreshIcon)
        refreshIcon.activateConstraints([
            refreshIcon.widthAnchor.constraint(equalToConstant: 16.67),
            refreshIcon.heightAnchor.constraint(equalToConstant: 19.28),
            refreshIcon.centerXAnchor.constraint(equalTo: self.refreshButton.centerXAnchor),
            refreshIcon.centerYAnchor.constraint(equalTo: self.refreshButton.centerYAnchor)
        ])
                
        self.moreButton.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        self.moreButton.titleLabel?.font = AILERON(17)
        self.moreButton.backgroundColor = CSS.shared.cyan
        self.moreButton.layer.cornerRadius = 5.0
        self.addSubview(self.moreButton)
        self.moreButton.activateConstraints([
            self.moreButton.heightAnchor.constraint(equalToConstant: 40),
            self.moreButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.margin),
            self.moreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                constant: IPHONE() ? -self.margin : -self.margin-80),
            self.moreButton.trailingAnchor.constraint(equalTo: self.refreshButton.leadingAnchor, constant: -10)
        ])
        self.moreButton.addTarget(self, action: #selector(moreButtonOnTap(_:)), for: .touchUpInside)
    }
    
    @objc func moreButtonOnTap(_ sender: UIButton?) {
        if(self.currentRows==2) {
            self.showRows(6, animate: true)
        } else if(self.currentRows==6) {
            self.showRows(2, animate: true)
        }
    }
    
    @objc func refreshButtonOnTap(_ sender: UIButton?) {
        var i = 0
        for rowView in self.rowsVStack.arrangedSubviews {
            for v in rowView.subviews {
                if let slider = v as? UISlider {
                    let value = LocalKeys.sliders.defaultValues[i]
                    slider.setValue(Float(value), animated: true)
                    
                    let key = LocalKeys.sliders.allKeys[i]
                    let strValue = String(format: "%02d", value)
                    WRITE(key, value: strValue)
                    
                    i += 1
                }
            }
        }
    
        self.delegate?.slidersPanelOnRefresh(sender: self)
    }
}


//        let handle = UIView()
//        handle.layer.cornerRadius = 2.5
//        handle.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.2) : UIColor(hex: 0xF0F0F0)
//        self.addSubview(handle)
//        handle.activateConstraints([
//            handle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            handle.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
//            handle.widthAnchor.constraint(equalToConstant: 50),
//            handle.heightAnchor.constraint(equalToConstant: 5),
//        ])
