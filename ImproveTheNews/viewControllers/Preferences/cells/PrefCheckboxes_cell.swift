//
//  PrefCheckboxes_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import UIKit

class PrefCheckboxes_cell: UITableViewCell {

    static let identifier = "PrefCheckboxes_cell"
    static let heigth: CGFloat = 300+16+16

    private let settings = [
        ("Show newspaper flags", LocalKeys.preferences.showSourceFlags),
        ("Show newspaper logo", LocalKeys.preferences.showSourceIcons),
        ("Show newspaper stance icon", LocalKeys.preferences.showStanceIcons),
        ("Show tips for new features", LocalKeys.preferences.showTips)
        //("Enable newspaper info popups", LocalKeys.preferences.showStancePopups),
        //("Show stories", LocalKeys.preferences.showStories)
    ]

    let mainContainer = UIView()
    let titleLabel = UILabel()
    let sourcesButton = UIButton(type: .custom)
    let sourcesLabel = UILabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.backgroundColor = .systemPink
        
        var sideMargin: CGFloat = 16
        //if(IPAD()){ sideMargin = 60 }
        
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.activateConstraints([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sideMargin),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -sideMargin),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
        
        self.titleLabel.font = DM_SERIF_DISPLAY(22)
        self.titleLabel.text = "Feed preferences"
        self.mainContainer.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 0),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 32),
        ])
        self.addSettings()
        
        let hBottomLine = UIView()
        hBottomLine.backgroundColor = self.contentView.backgroundColor
        self.contentView.addSubview(hBottomLine)
        hBottomLine.activateConstraints([
            hBottomLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            hBottomLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            hBottomLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            hBottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        ADD_HDASHES(to: hBottomLine)
        
        self.refreshDisplayMode()
    }
    
    func addSettings() {
        let vStack = VSTACK(into: self.mainContainer)
        vStack.backgroundColor = .clear
        vStack.spacing = 16
        vStack.tag = 22
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 0),
            vStack.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: 0),
            vStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16)
        ])
    
        for (i, data) in self.settings.enumerated() {
            let hStack = HSTACK(into: vStack)
            //hStack.backgroundColor = .green
            
            let itemText = UILabel()
            itemText.font = AILERON(16)
            itemText.text = data.0
            itemText.textColor = .white
            hStack.addArrangedSubview(itemText)
            
            if(IPAD()) {
                itemText.widthAnchor.constraint(equalToConstant: 400).isActive = true
            }
            
            var value = true
            let key = self.settings[i].1
            if let strValue = READ(key) {
                if(strValue == "00"){ value = false }
            }
            
            let check = OnOffView()
            check.status = value
            check.thumbOnColor = UIColor(hex: 0xDA4933)
            check.thumbOffColor = UIColor(hex: 0xBBBDC0)
            check.delegate = self
            check.tag = 50 + i
            hStack.addArrangedSubview(check)
            
            if(IPAD()) {
                ADD_SPACER(to: hStack)
            }
        }
        
        self.mainContainer.addSubview(self.sourcesButton)
        self.sourcesButton.activateConstraints([
            self.sourcesButton.heightAnchor.constraint(equalToConstant: 40),
            self.sourcesButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 24)
        ])
        if(IPHONE()) {
            self.sourcesButton.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 0).isActive = true
            self.sourcesButton.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: 0).isActive = true
        } else {
            self.sourcesButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
            self.sourcesButton.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor).isActive = true
        }
        
        self.sourcesButton.layer.cornerRadius = 6
        self.sourcesButton.addTarget(self, action: #selector(sourcesButtonTap(_:)), for: .touchUpInside)
        
        self.sourcesLabel.font = AILERON_SEMIBOLD(16)
        self.sourcesLabel.text = "Show source filters"
        self.mainContainer.addSubview(self.sourcesLabel)
        self.sourcesLabel.activateConstraints([
            self.sourcesLabel.centerXAnchor.constraint(equalTo: self.sourcesButton.centerXAnchor),
            self.sourcesLabel.centerYAnchor.constraint(equalTo: self.sourcesButton.centerYAnchor)
        ])
    }
    
    
    //MARK: - misc
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.mainContainer.backgroundColor = self.contentView.backgroundColor
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        
        let vStack = self.mainContainer.viewWithTag(22) as! UIStackView
        for v in vStack.arrangedSubviews {
            let hStack = v as! UIStackView
            
            let label = hStack.arrangedSubviews[0] as! UILabel
            label.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
            
//            let onOff = hStack.arrangedSubviews[1] as! OnOffView
//            if(onOff.status) {
//                onOff.backgroundColor = DARK_MODE() ? UIColor(hex: 0x823129) : UIColor(hex: 0xE6A49D)
//            } else {
//                onOff.backgroundColor = DARK_MODE() ? UIColor(hex: 0x68686A) : UIColor(hex: 0xA1A2A3)
//            }
        }
        
        self.sourcesButton.backgroundColor = UIColor(hex: 0x60C4D6)
        self.sourcesLabel.textColor = UIColor(hex: 0x19191C)
    }
    
    // MARK: - Event(s)
    @objc func sourcesButtonTap(_ sender: UIButton) {
        var vc: UIViewController!
        
        if(IPHONE()) {
            vc = SourceFilter_iPhoneViewController()
        }else {
            vc = SourceFilterViewController()
        }
        
        vc.modalPresentationStyle = .fullScreen
        CustomNavController.shared.present(vc, animated: true)
    }

}

extension PrefCheckboxes_cell: OnOffViewDelegate {

    func OnOffView_onValueChanged(sender: OnOffView, newValue: Bool) {
        let tag = sender.tag - 50
        let key = self.settings[tag].1
        
        if(newValue){ WRITE(key, value: "01") }
        else{ WRITE(key, value: "00") }
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        
        NOTIFY(Notification_reloadMainFeedOnShow)
    }
    
}
