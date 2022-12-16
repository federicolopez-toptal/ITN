//
//  PrefCheckboxes_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import UIKit

class PrefCheckboxes_cell: UITableViewCell {

    static let identifier = "PrefCheckboxes_cell"
    static let heigth: CGFloat = 300

    private let settings = [
        ("Show source icons", LocalKeys.preferences.showSourceIcons),
        ("Show newspaper stance icon", LocalKeys.preferences.showStanceIcons),
        ("Enable newspaper info popups", LocalKeys.preferences.showStancePopups),
        ("Show stories", LocalKeys.preferences.showStories)
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
        
        self.contentView.addSubview(self.mainContainer)
        self.mainContainer.activateConstraints([
            self.mainContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.mainContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
        
        self.titleLabel.font = MERRIWEATHER_BOLD(17)
        self.titleLabel.text = "Feed preferences"
        self.mainContainer.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 28),
        ])
        self.addSettings()
        
        self.refreshDisplayMode()
    }
    
    func addSettings() {
        let vStack = VSTACK(into: self.mainContainer)
        vStack.backgroundColor = .clear
        vStack.spacing = 12
        vStack.tag = 22
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 25)
        ])
    
        for (i, data) in self.settings.enumerated() {
            let hStack = HSTACK(into: vStack)
            hStack.backgroundColor = .clear //.green
            
            let itemText = UILabel()
            itemText.font = ROBOTO(15)
            itemText.text = data.0
            itemText.textColor = .white
            hStack.addArrangedSubview(itemText)
            
            var value = true
            let key = self.settings[i].1
            if let strValue = READ(key) {
                if(strValue == "00"){ value = false }
            }
            
            let check = OnOffView()
            check.status = value
            check.thumbOnColor = UIColor(hex: 0xFF643C)
            check.thumbOffColor = UIColor(hex: 0x93A0B4)
            check.delegate = self
            check.tag = 50 + i
            hStack.addArrangedSubview(check)
        }
        
        self.mainContainer.addSubview(self.sourcesButton)
        self.sourcesButton.activateConstraints([
            self.sourcesButton.leadingAnchor.constraint(equalTo: self.mainContainer.leadingAnchor, constant: 16),
            self.sourcesButton.trailingAnchor.constraint(equalTo: self.mainContainer.trailingAnchor, constant: -16),
            self.sourcesButton.heightAnchor.constraint(equalToConstant: 35),
            self.sourcesButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20)
        ])
        self.sourcesButton.layer.cornerRadius = 4
        self.sourcesButton.addTarget(self, action: #selector(sourcesButtonTap(_:)), for: .touchUpInside)
        
        self.sourcesLabel.font = ROBOTO_BOLD(11)
        self.sourcesLabel.text = "SHOW SOURCE FILTERS"
        self.mainContainer.addSubview(self.sourcesLabel)
        self.sourcesLabel.activateConstraints([
            self.sourcesLabel.centerXAnchor.constraint(equalTo: self.sourcesButton.centerXAnchor),
            self.sourcesLabel.centerYAnchor.constraint(equalTo: self.sourcesButton.centerYAnchor)
        ])
    }
    
    
    //MARK: - misc
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainContainer.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19202D).withAlphaComponent(0.4) : UIColor(hex: 0xF4F6F8)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        
        let vStack = self.mainContainer.viewWithTag(22) as! UIStackView
        for v in vStack.arrangedSubviews {
            let hStack = v as! UIStackView
            
            let label = hStack.arrangedSubviews[0] as! UILabel
            label.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
            
            let onOff = hStack.arrangedSubviews[1] as! OnOffView
            onOff.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : .white
        }
        
        self.sourcesButton.backgroundColor = DARK_MODE() ? UIColor(hex: 0x283241) : UIColor(hex: 0xB4BDCA)
        self.sourcesLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : .white
    }
    
    // MARK: - Event(s)
    @objc func sourcesButtonTap(_ sender: UIButton) {
        let vc = SourceFilterViewController()
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
        
//        NOTIFY(Notification_reloadMainFeed)
    }
    
}
