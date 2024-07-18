//
//  TopicShownTextCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/07/2024.
//

import UIKit

class TopicShownTextCell: UITableViewCell {
    
    static let identifier = "TopicShownTextCell"
    static var height: CGFloat = 60
    
    var customTextLabel = UILabel()
    
    
    // MARK: - Start
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.customTextLabel.font = CSS.shared.iPhoneArticle_titleFont
        
        self.contentView.addSubview(self.customTextLabel)
        self.customTextLabel.activateConstraints([
            self.customTextLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                constant: CSS.shared.iPhoneSide_padding),
            self.customTextLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    func populate(with text: String) {
        let _text = "Showing \(text) articles."
    
        let attributedString = NSMutableAttributedString(string: _text, attributes: [
            .font: AILERON(16),
            .foregroundColor: CSS.shared.displayMode().sec_textColor
        ])
        let topicAttributedString = NSMutableAttributedString(string: text, attributes: [
            .font: AILERON(16),
            .foregroundColor: DARK_MODE() ? UIColor.white : CSS.shared.displayMode().sec_textColor
        ])
        
        let range = (attributedString.string as NSString).range(of: text)
        attributedString.replaceCharacters(in: range, with: topicAttributedString)
        
        self.customTextLabel.attributedText = attributedString
        
        
        //self.customTextLabel.text = "Showing \(text) articles"
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = CSS.shared.displayMode().main_bgColor
    }

}
