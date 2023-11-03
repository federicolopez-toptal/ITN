//
//  iPhoneFooterCell_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class iPhoneFooterCell_v3: UITableViewCell {
    static let identifier = "iPhoneFooterCell_v3"
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        //top line
        let topLine = UIView()
        self.contentView.addSubview(topLine)
        topLine.activateConstraints([
            topLine.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1),
        ])
        topLine.tag = 11
        
        let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verity.logo")))
        self.contentView.addSubview(logo)
        logo.activateConstraints([
            logo.widthAnchor.constraint(equalToConstant: 121),
            logo.heightAnchor.constraint(equalToConstant: 25),
            logo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 36),
            logo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
        
        let slidersItem = createItem(text: "How our sliders work")
        self.contentView.addSubview(slidersItem)
        slidersItem.activateConstraints([
            slidersItem.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 32),
            slidersItem.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
        
        self.refreshDisplayMode()
    }
    
    func createItem(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = CSS.shared.iPhoneFooter_font
        
        let buttonArea = UIButton(type: .system)
        buttonArea.backgroundColor = .red.withAlphaComponent(0.25)
        label.superview!.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -5),
            buttonArea.topAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            buttonArea.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ])
        
        return label
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        if let topLine = self.viewWithTag(11) {
            topLine.backgroundColor = CSS.shared.displayMode().main_bgColor
            self.addDashesTo(topLine)
        }
    }
    
}

extension iPhoneFooterCell_v3 {
    private func addDashesTo(_ view: UIView) {
        REMOVE_ALL_SUBVIEWS(from: view)
        
        var valX: CGFloat = 0
        var maxDim: CGFloat = SCREEN_SIZE().width
        if(SCREEN_SIZE().height > maxDim) { maxDim = SCREEN_SIZE().height }
        
        while(valX < maxDim) {
            let dashView = UIView()
            dashView.backgroundColor = CSS.shared.displayMode().line_color
            view.addSubview(dashView)
            dashView.activateConstraints([
                dashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: valX),
                dashView.widthAnchor.constraint(equalToConstant: CSS.shared.dashedLine_width),
                dashView.topAnchor.constraint(equalTo: view.topAnchor),
                dashView.heightAnchor.constraint(equalToConstant: 1)
            ])
        
            valX += (CSS.shared.dashedLine_width * 2)
        }
    }
    
    static func getHeight() -> CGFloat {
        return 330 + 100
    }
}
