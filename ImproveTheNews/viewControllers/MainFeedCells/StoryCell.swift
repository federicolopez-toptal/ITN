//
//  StoryCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 09/09/2022.
//

import UIKit

class StoryCell: UITableViewCell {

    static let identifier = "StoryCell"

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
        
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.backgroundColor = .lightGray
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
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .yellow
        titleLabel.textColor = UIColor(hex: 0x1D242F)
        titleLabel.numberOfLines = 3
        titleLabel.font = merriweather_bold
        titleLabel.text = "Vaccine required for NHS health care workers"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.65
        vStack.addArrangedSubview(titleLabel)
        
        self.addSpacer(to: vStack, height: 10)
        //----------------------------------------
        let sourcesHStack = self.createHorizontalStackView(into: vStack)
        sourcesHStack.spacing = 5
        
        let lastUpdatedLabel = UILabel()
        lastUpdatedLabel.text = "Last updated 2 hours ago"
        lastUpdatedLabel.textColor = .black
        lastUpdatedLabel.font = roboto
        sourcesHStack.addArrangedSubview(lastUpdatedLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        sourcesHStack.addArrangedSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        self.addSpacer(to: sourcesHStack, backgroundColor: .systemPink)
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
        print(story.isStory)
        print(story.storySources.count)
    }
    
}
