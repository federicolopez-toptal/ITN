//
//  StoryCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 09/09/2022.
//

import UIKit
import SDWebImage


class StoryCell: UITableViewCell {

    static let identifier = "StoryCell"
    static let heigth: CGFloat = 248

    let mainImageView = UIImageView()
    let gradient = UIImageView()
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
    
}

extension StoryCell {
    
    private func buildContent() {
        self.backgroundColor = .white
        
        self.mainImageView.backgroundColor = .gray
        self.addSubview(self.mainImageView)
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        
        self.gradient.backgroundColor = .clear
        self.addSubview(self.gradient)
        self.gradient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.gradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.gradient.topAnchor.constraint(equalTo: self.topAnchor),
            self.gradient.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.gradient.contentMode = .scaleToFill
        self.gradient.clipsToBounds = true
        
        let vStack = VSTACK(into: self)
        vStack.backgroundColor = .clear //.lightGray
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
    let roboto_bold = UIFont(name: "Roboto-Bold", size: 13)
    let roboto = UIFont(name: "Roboto-Regular", size: 13)
    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 18)
    let characterSpacing: Double = 1.35
        
        let storyHStack = HSTACK(into: vStack)

        let storyLabel = UILabel()
        storyLabel.backgroundColor = UIColor(hex: 0xFF643C)
        storyLabel.textColor = .white
        storyLabel.text = "STORY"
        storyLabel.textAlignment = .center
        storyLabel.font = roboto_bold
        storyLabel.layer.masksToBounds = true
        storyLabel.layer.cornerRadius = 12
        storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        storyHStack.addArrangedSubview(storyLabel)
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.65
        vStack.addArrangedSubview(self.titleLabel)
        
        ADD_SPACER(to: vStack, height: 10)
        //----------------------------------------
        let sourcesHStack = HSTACK(into: vStack, spacing: 5.0)
        sourcesHStack.addArrangedSubview(sourcesContainer)
        sourcesContainer.hide()
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = UIColor(hex: 0x1D242F)
        self.timeLabel.font = roboto
        sourcesHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        sourcesHStack.addArrangedSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        ADD_SPACER(to: sourcesHStack)
        vStack.addArrangedSubview(sourcesHStack)
        
        ADD_SPACER(to: vStack, height: 10)
        //----------------------------------------
        
    }
    
}

extension StoryCell {
    
    func populate(with story: MainFeedArticle) {
        self.mainImageView.image = nil
        if let _url = URL(string: story.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }
        
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
        ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
    
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.gradient.image = UIImage(named: DisplayMode.imageName("story.gradient"))
    }
}
