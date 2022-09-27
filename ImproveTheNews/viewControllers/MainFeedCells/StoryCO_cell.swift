//
//  StoryCO_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/09/2022.
//

import UIKit

class StoryCO_cell: UICollectionViewCell {

    static let identifier = "StoryCO_cell"
    //private let HEIGHT: CGFloat = 0.0     Height based on content!
    var column: Int = 1
    
    var mainVStack: UIStackView!
    let mainImageView = UIImageView()
    let gradient = UIImageView()
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let targetSize = CGSize(width: SCREEN_SIZE().width/2, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        return layoutAttributes
    }
    
}

extension StoryCO_cell {

    private func buildContent() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            self.contentView.heightAnchor.constraint(equalToConstant: 200)
            self.contentView.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width/2)
        ])
        self.contentView.backgroundColor = .white
        
    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 18)
    let roboto = UIFont(name: "Roboto-Regular", size: 13)
    let roboto_bold = UIFont(name: "Roboto-Bold", size: 11)
    let characterSpacing: Double = 1.35
    
        let W: CGFloat = (SCREEN_SIZE().width/2) - 32
    
        self.mainVStack = VSTACK(into: self.contentView)
        self.mainVStack.backgroundColor = .green
        self.mainVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //self.mainVStack.widthAnchor.constraint(equalToConstant: W),
            
            self.mainVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainVStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainVStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.mainVStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16) // cell height
        ])
        
        self.mainImageView.backgroundColor = .gray
        self.mainVStack.addArrangedSubview(self.mainImageView)
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        ADD_SPACER(to: self.mainVStack, height: 5)

        self.gradient.backgroundColor = .clear
        self.mainVStack.addSubview(self.gradient)
        self.gradient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.gradient.leadingAnchor.constraint(equalTo: self.mainVStack.leadingAnchor),
            self.gradient.trailingAnchor.constraint(equalTo: self.mainVStack.trailingAnchor),
            self.gradient.heightAnchor.constraint(equalToConstant: 45),
            self.gradient.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor),
        ])
        self.gradient.contentMode = .scaleToFill
        self.gradient.clipsToBounds = true

        self.storyLabel.backgroundColor = UIColor(hex: 0xFF643C)
        self.storyLabel.textColor = .white
        self.storyLabel.text = "STORY"
        self.storyLabel.textAlignment = .center
        self.storyLabel.font = roboto_bold
        self.storyLabel.layer.masksToBounds = true
        self.storyLabel.layer.cornerRadius = 12
        self.storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        self.mainVStack.addSubview(self.storyLabel)
        self.storyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.storyLabel.leadingAnchor.constraint(equalTo: self.mainVStack.leadingAnchor, constant: 6),
            self.storyLabel.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 0),
            self.storyLabel.widthAnchor.constraint(equalToConstant: 65),
            self.storyLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        


        let infoHStack = HSTACK(into: self.mainVStack)
        infoHStack.backgroundColor = .clear //.orange
        ADD_SPACER(to: infoHStack, width: 7)
        let infoVStack = VSTACK(into: infoHStack)
        infoVStack.backgroundColor = .clear //.blue
        //ADD_SPACER(to: infoVStack, height: 200)
        ADD_SPACER(to: infoHStack, width: 7)

        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = UIColor(hex: 0x1D242F)
        self.titleLabel.numberOfLines = 5
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Vaccine required for NHS health care workers"
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        infoVStack.addArrangedSubview(self.titleLabel)
        ADD_SPACER(to: infoVStack, height: 10)
        infoVStack.addArrangedSubview(self.sourcesContainer)
        ADD_SPACER(to: infoVStack, height: 10)
        
        let updateHStack = HSTACK(into: infoVStack)
        updateHStack.spacing = 5.0
        
        self.timeLabel.text = "Updated 2 hours ago"
        self.timeLabel.textColor = UIColor(hex: 0x1D242F)
        self.timeLabel.font = roboto
        self.timeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        updateHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        updateHStack.addArrangedSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        ADD_SPACER(to: updateHStack)
        
        
        ADD_SPACER(to: infoVStack, height: 12)
    }

    func populate(with story: MainFeedArticle, column: Int) {
        self.column = column
    
        self.mainImageView.image = nil
        if let _url = URL(string: story.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }

        self.titleLabel.text = story.title
        ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = .yellow //DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        //self.mainVStack.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.gradient.image = UIImage(named: DisplayMode.imageName("story.gradient"))
        
        self.storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
    }
}
