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

    let mainImageView = UIImageView()
    let gradient = UIImageView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StoryCell {
    
    private func buildContent() {
        self.backgroundColor = .white
        
        self.mainImageView.backgroundColor = .darkGray
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
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.backgroundColor = .clear //.lightGray
        self.addSubview(vStack)
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
        
        let storyHStack = self.createHorizontalStackView(into: vStack)
        
        // "story" orange label
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
        
        self.addSpacer(to: storyHStack)
        self.addSpacer(to: vStack, height: 8)
        //----------------------------------------
    
        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = UIColor(hex: 0x1D242F)
        self.titleLabel.numberOfLines = 3
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Vaccine required for NHS health care workers"
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.65
        vStack.addArrangedSubview(self.titleLabel)
        
        self.addSpacer(to: vStack, height: 10)
        //----------------------------------------
        let sourcesHStack = self.createHorizontalStackView(into: vStack)
        sourcesHStack.spacing = 5
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = .black
        self.timeLabel.font = roboto
        sourcesHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        sourcesHStack.addArrangedSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        self.addSpacer(to: sourcesHStack)
        vStack.addArrangedSubview(sourcesHStack)
        
        self.addSpacer(to: vStack, height: 10)
        //----------------------------------------
        
    }
    
    private func createHorizontalStackView(into stackView: UIStackView) -> UIStackView {
        let result = UIStackView()
        result.axis = .horizontal
        stackView.addArrangedSubview(result)
        
        return result
    }
    
    private func addSpacer(to stackView: UIStackView, backgroundColor: UIColor = .clear, height: CGFloat? = nil) {
        let spacer = UIView()
        spacer.backgroundColor = backgroundColor
        stackView.addArrangedSubview(spacer)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        if let _height = height {
            spacer.heightAnchor.constraint(equalToConstant: _height).isActive = true
        }
    }
    
}

extension StoryCell {
    
    func populate(with story: MainFeedArticle) {
        self.mainImageView.image = nil
        if let _url = URL(string: story.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }
        
        self.gradient.image = UIImage(named: DisplayMode.imageName("story.gradient"))
        
        self.titleLabel.text = story.title
        self.timeLabel.text = "Last updated " + story.time
    }
    
}
