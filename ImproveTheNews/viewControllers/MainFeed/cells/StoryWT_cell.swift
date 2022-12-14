//
//  StoryWT_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/09/2022.
//

import UIKit

class StoryWT_cell: UICollectionViewCell {

    static let identifier = "StoryWT_cell"
    static let merriweather_bold = MERRIWEATHER_BOLD(17)

    let storyLabel = UILabel()
    let titleLabel = StoryWT_cell.createTitleLabel(text: "Lorem ipsum")
    let sourcesContainer = UIStackView()
    let timeLabel = UILabel()



    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // -----------------------------------
    private func buildContent() {
        self.contentView.backgroundColor = .white
        
    let roboto_bold = ROBOTO_BOLD(11)
    let characterSpacing: Double = 1.35
    let roboto = ROBOTO(13)
        
        self.storyLabel.backgroundColor = UIColor(hex: 0xFF643C)
        self.storyLabel.textColor = .white
        self.storyLabel.text = "STORY"
        self.storyLabel.textAlignment = .center
        self.storyLabel.font = roboto_bold
        self.storyLabel.layer.masksToBounds = true
        self.storyLabel.layer.cornerRadius = 12
        self.storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        self.contentView.addSubview(self.storyLabel)
        self.storyLabel.activateConstraints([
            self.storyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.storyLabel.widthAnchor.constraint(equalToConstant: 65),
            self.storyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.storyLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        self.titleLabel.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)
        self.titleLabel.textColor = .black
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.topAnchor.constraint(equalTo: self.storyLabel.bottomAnchor, constant: 8),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        let iconsHStack = HSTACK(into: self.contentView, spacing: 5.0)
        iconsHStack.backgroundColor = .clear //.orange.withAlphaComponent(0.3)
        iconsHStack.activateConstraints([
            iconsHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            iconsHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            iconsHStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            iconsHStack.heightAnchor.constraint(equalToConstant: 18)
        ])
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = .black
        self.timeLabel.font = roboto
        self.timeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        iconsHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        iconsHStack.addArrangedSubview(arrow)
        arrow.activateConstraints([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        ADD_SPACER(to: iconsHStack)
    }
    
    func populate(with story: MainFeedArticle) {
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
        if( READ(LocalKeys.preferences.showSourceIcons) == "01" ) {
            ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
        } else {
            ADD_SOURCE_ICONS(data: [], to: self.sourcesContainer)
        }
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        //.systemPink.withAlphaComponent(0.5)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        
        self.storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
        self.storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
    
    
    static func createTitleLabel(text: String) -> UILabel {
        let result = UILabel()
        result.numberOfLines = 8
        result.font = StoryWT_cell.merriweather_bold
        result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        result.text = text
        
        return result
    }
    
    static func calculateHeight(text: String, width: CGFloat) -> CGSize {
        let storyLabelH: CGFloat = 23
        
        let textW: CGFloat = width-(16*2)
        let tmpTitleLabel = StoryWT_cell.createTitleLabel(text: text)
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        let sourcesH: CGFloat = 18
        
        let H: CGFloat = 16 + storyLabelH + 8 + textH + 10 + sourcesH + 16 + 5
        return CGSize(width: width, height: H)
    }
    
}
