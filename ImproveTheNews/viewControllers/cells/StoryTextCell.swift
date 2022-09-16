//
//  StoryTextCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/09/2022.
//

import UIKit

class StoryTextCell: UITableViewCell {

    static let identifier = "StoryTextCell"

    let storyLabel = UILabel()
    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let timeLabel = UILabel()


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
        self.backgroundColor = .white
        
    let roboto_bold = UIFont(name: "Roboto-Bold", size: 13)
    let characterSpacing: Double = 1.35
    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 17)
    let roboto = UIFont(name: "Roboto-Regular", size: 13)
        
        self.storyLabel.backgroundColor = UIColor(hex: 0xFF643C)
        self.storyLabel.textColor = .white
        self.storyLabel.text = "STORY"
        self.storyLabel.textAlignment = .center
        self.storyLabel.font = roboto_bold
        self.storyLabel.layer.masksToBounds = true
        self.storyLabel.layer.cornerRadius = 12
        self.storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        self.addSubview(self.storyLabel)
        self.storyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.storyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.storyLabel.widthAnchor.constraint(equalToConstant: 65),
            self.storyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.storyLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = .black
        self.titleLabel.numberOfLines = 3
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Test title"
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.65
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.storyLabel.bottomAnchor, constant: 8),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        let iconsHStack = HSTACK(into: self, spacing: 5.0)
        iconsHStack.backgroundColor = .clear //.orange
        iconsHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconsHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconsHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            iconsHStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            iconsHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = .black
        self.timeLabel.font = roboto
        iconsHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        iconsHStack.addArrangedSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        ADD_SPACER(to: iconsHStack)
    }

}


extension StoryTextCell {
    
    func populate(with story: MainFeedArticle) {
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
        ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)

        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        
        self.storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
        self.storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
    
}
