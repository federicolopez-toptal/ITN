//
//  StoryWT_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/09/2022.
//

import UIKit

class StoryWT_cell: UICollectionViewCell {

    static let identifier = "StoryWT_cell"
    static let merriweather_bold =  DM_SERIF_DISPLAY_fixed(17) //MERRIWEATHER_BOLD(17)

    let storyLabel = UILabel()
    let titleLabel = StoryWT_cell.createTitleLabel(text: "Lorem ipsum")
    let sourcesContainer = UIStackView()
    let timeLabel = UILabel()

    static var extraHeight: CGFloat = 8.0
    var marginViewHeightConstraint: NSLayoutConstraint? = nil
    let marginView = UIView()
    let bottomView = UIView()

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
        
        if(MUST_SPLIT()==0) {
            StoryWT_cell.extraHeight = 0
        } else {
            StoryWT_cell.extraHeight = 8
        }
        
    let aileronBold = AILERON_BOLD(11)
    let characterSpacing: Double = 1.35
    let roboto = ROBOTO(13)
        
        self.storyLabel.backgroundColor = UIColor(hex: 0xDA4933)
        self.storyLabel.textColor = .white
        self.storyLabel.text = "STORY"
        self.storyLabel.textAlignment = .center
        self.storyLabel.font = aileronBold
        self.storyLabel.layer.masksToBounds = true
        self.storyLabel.layer.cornerRadius = 10
        self.storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        self.contentView.addSubview(self.storyLabel)
        self.storyLabel.activateConstraints([
            self.storyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16+StoryWT_cell.extraHeight),
            self.storyLabel.widthAnchor.constraint(equalToConstant: 60),
            self.storyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.storyLabel.heightAnchor.constraint(equalToConstant: 20)
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
        
        self.contentView.addSubview(self.marginView)
        self.marginViewHeightConstraint = self.marginView.heightAnchor.constraint(equalToConstant: StoryWT_cell.extraHeight)
        self.marginView.activateConstraints([
            self.marginView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.marginView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.marginView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.marginViewHeightConstraint!
        ])
        
        //---
        self.contentView.addSubview(self.bottomView)
        self.bottomView.activateConstraints([
            self.bottomView.heightAnchor.constraint(equalToConstant: 12),
            self.bottomView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.bottomView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.bottomView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        ADD_SPACER(to: iconsHStack)
    }
    
    func populate(with story: MainFeedArticle) {
        if(MUST_SPLIT()==0) {
            StoryWT_cell.extraHeight = 0
        } else {
            StoryWT_cell.extraHeight = 8
        }
        self.marginViewHeightConstraint?.constant = StoryWT_cell.extraHeight
        
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
        if( READ(LocalKeys.preferences.showSourceIcons) == "01" ) {
            ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
        } else {
            ADD_SOURCE_ICONS(data: [], to: self.sourcesContainer)
        }
        
        if(Layout.current() == .textImages && MUST_SPLIT() == 0){ self.bottomView.show() }
        else { self.bottomView.hide() }
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE9EAEB)
        self.marginView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        self.bottomView.backgroundColor = self.marginView.backgroundColor
        
        //self.storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
        self.storyLabel.backgroundColor = UIColor(hex: 0xDA4933)
        //self.storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.storyLabel.textColor = .white
        
//        self.contentView.backgroundColor = .systemPink
    }
    
    
    static func createTitleLabel(text: String) -> UILabel {
        let result = UILabel()
        result.numberOfLines = 0
        result.font = StoryWT_cell.merriweather_bold
        //result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        result.text = text
        
        return result
    }
    
    static func calculateHeight(text: String, width: CGFloat) -> CGSize {
        let storyLabelH: CGFloat = 23
        
        let textW: CGFloat = width-(16*2)
        let tmpTitleLabel = StoryWT_cell.createTitleLabel(text: text)
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        let sourcesH: CGFloat = 18
        
        var H: CGFloat = 16 + storyLabelH + 8 + textH + 10 + sourcesH + 16
        H += StoryWT_cell.extraHeight
//        let minH: CGFloat = 147
//        if(H<minH){ H = minH }
        
        if(Layout.current() == .textImages && MUST_SPLIT() == 0){ H += 12 }
        return CGSize(width: width, height: H)
    }
    
}
