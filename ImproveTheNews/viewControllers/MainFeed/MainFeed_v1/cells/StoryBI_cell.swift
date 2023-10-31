//
//  StoryBI_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 09/09/2022.
//

import UIKit
import SDWebImage


class StoryBI_cell: UICollectionViewCell {

    static let identifier = "StoryBI_cell"
    
    
    let mainImageView = UIImageView()
    let gradient = UIImageView()
    let gradientBottom = UIView()
    let titleLabel = UILabel()
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
    
        self.mainImageView.backgroundColor = .gray
        self.contentView.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.mainImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        
        let vStack = VSTACK(into: self.contentView)
        vStack.backgroundColor = .clear //.lightGray
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
    let aileronBold = AILERON_BOLD(11)
    let roboto = ROBOTO(13)
    let merriweather_bold = DM_SERIF_DISPLAY_fixed(18) //MERRIWEATHER_BOLD(18)
    let characterSpacing: Double = 1.0 //35
        
        let storyHStack = HSTACK(into: vStack)

        let storyLabel = UILabel()
        storyLabel.backgroundColor = UIColor(hex: 0xDA4933)
        storyLabel.textColor = .white
        storyLabel.text = "STORY"
        storyLabel.textAlignment = .center
        storyLabel.font = aileronBold
        storyLabel.layer.masksToBounds = true
        storyLabel.layer.cornerRadius = 12
        storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        storyHStack.addArrangedSubview(storyLabel)
        storyLabel.activateConstraints([
            storyLabel.widthAnchor.constraint(equalToConstant: 65),
            storyLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        ADD_SPACER(to: storyHStack)
        ADD_SPACER(to: vStack, height: 8)
        //----------------------------------------
    
        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = UIColor(hex: 0x1D242F)
        self.titleLabel.numberOfLines = 3
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Vaccine required for NHS health care workers"
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        vStack.addArrangedSubview(self.titleLabel)
        
        ADD_SPACER(to: vStack, height: 10)
        //----------------------------------------
        let sourcesHStack = HSTACK(into: vStack, spacing: 5.0)
        sourcesHStack.addArrangedSubview(sourcesContainer)
        sourcesContainer.hide()
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = UIColor(hex: 0x1D242F)
        self.timeLabel.font = roboto
        self.timeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        sourcesHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        sourcesHStack.addArrangedSubview(arrow)
        arrow.activateConstraints([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        ADD_SPACER(to: sourcesHStack)
        vStack.addArrangedSubview(sourcesHStack)
        
        ADD_SPACER(to: vStack, height: 10)
        //----------------------------------------
        
        self.gradient.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.contentView.addSubview(self.gradient)
        self.gradient.activateConstraints([
            self.gradient.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.gradient.topAnchor.constraint(equalTo: storyLabel.topAnchor, constant: -20),
            self.gradient.heightAnchor.constraint(equalToConstant: 80),
            self.gradient.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        ])
        self.gradient.contentMode = .scaleToFill
        self.gradient.clipsToBounds = true
        
        self.gradientBottom.backgroundColor = .red
        //self.gradientBottom.alpha = self.gradient.alpha
        self.contentView.addSubview(gradientBottom)
        self.gradientBottom.activateConstraints([
            self.gradientBottom.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.gradientBottom.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.gradientBottom.topAnchor.constraint(equalTo: self.gradient.bottomAnchor),
            self.gradientBottom.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
        
        vStack.superview?.bringSubviewToFront(vStack)
    }
    
    func populate(with story: MainFeedArticle) {
        self.mainImageView.image = nil
        if let _url = URL(string: story.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }
        
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
        
        if( READ(LocalKeys.preferences.showSourceIcons) == "01" ) {
            ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
        } else {
            ADD_SOURCE_ICONS(data: [], to: self.sourcesContainer)
        }
        
        let sourcesHeight: CGFloat = 18
        let titleHeight: CGFloat = self.titleLabel.calculateHeightFor(width: SCREEN_SIZE().width - 16 - 16)
        let storyLabelHeight: CGFloat = 23
        let topMargin: CGFloat = 40
        let H: CGFloat = 16 + 10 + sourcesHeight + 10 + titleHeight + 8 + storyLabelHeight + topMargin
        //self.gradientTopConstraint?.constant = H
        
        
        
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainImageView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : .lightGray
        
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        
        self.gradient.image = UIImage(named: DisplayMode.imageName("story.shortGradient"))
        self.gradientBottom.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE9EAEB)
        self.gradient.alpha = 1.0
        //self.gradientBottom.alpha = self.gradient.alpha
    }
    
    static func getHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 248)
    }
    
}
