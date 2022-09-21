//
//  StoryWT_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/09/2022.
//

import UIKit

class StoryWT_cell: UICollectionViewCell {

    static let identifier = "StoryWT_cell"
    //private let HEIGHT: CGFloat = 1.0     Height based on content!
    private let WIDTH: CGFloat = SCREEN_SIZE().width

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: self.WIDTH)
        width.isActive = true
        return width
    }()

    let storyLabel = UILabel()
    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let timeLabel = UILabel()



    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        width.constant = self.WIDTH
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}

extension StoryWT_cell {

    private func buildContent() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //self.contentView.heightAnchor.constraint(equalToConstant: self.HEIGHT)
        ])
        self.contentView.backgroundColor = .white
        
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
        self.contentView.addSubview(self.storyLabel)
        self.storyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.storyLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.storyLabel.widthAnchor.constraint(equalToConstant: 65),
            self.storyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.storyLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = .black
        self.titleLabel.numberOfLines = 3
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Test title"
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.storyLabel.bottomAnchor, constant: 8),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        let iconsHStack = HSTACK(into: self.contentView, spacing: 5.0)
        iconsHStack.backgroundColor = .clear //.orange
        iconsHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconsHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            iconsHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            iconsHStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            iconsHStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16) // cell height
        ])
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = .black
        self.timeLabel.font = roboto
        self.timeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
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
    
    func populate(with story: MainFeedArticle) {
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
        ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)

        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        
        self.storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
        self.storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
    }
    
}
