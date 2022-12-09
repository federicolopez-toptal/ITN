//
//  StoryCT_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 30/10/2022.
//

import UIKit

class StoryCT_cell: UICollectionViewCell {

    static let identifier = "StoryCT_cell"
    static let merriweather_bold = MERRIWEATHER_BOLD(18)
    var column: Int = 1
    
    var mainVStack: UIStackView!
    let storyLabel = UILabel()
    var titleLabel = StoryCT_cell.createTitleLabel(text: "Lorem ipsum")
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
        
    let roboto = ROBOTO(13)
    let roboto_bold = ROBOTO_BOLD(11)
    let characterSpacing: Double = 1.35
    
        self.mainVStack = VSTACK(into: self.contentView)
        self.mainVStack.backgroundColor = .green
        self.mainVStack.activateConstraints([
            self.mainVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainVStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainVStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        ])
        
        ADD_SPACER(to: self.mainVStack, height: 40)
        
        self.storyLabel.backgroundColor = UIColor(hex: 0xFF643C)
        self.storyLabel.textColor = .white
        self.storyLabel.text = "STORY"
        self.storyLabel.textAlignment = .center
        self.storyLabel.font = roboto_bold
        self.storyLabel.layer.masksToBounds = true
        self.storyLabel.layer.cornerRadius = 12
        self.storyLabel.addCharacterSpacing(kernValue: characterSpacing)
        self.mainVStack.addSubview(self.storyLabel)
        self.storyLabel.activateConstraints([
            self.storyLabel.leadingAnchor.constraint(equalTo: self.mainVStack.leadingAnchor, constant: 6),
            self.storyLabel.widthAnchor.constraint(equalToConstant: 65),
            self.storyLabel.heightAnchor.constraint(equalToConstant: 23),
            self.storyLabel.topAnchor.constraint(equalTo: self.mainVStack.topAnchor, constant: 10),
        ])
        
        let infoHStack = HSTACK(into: self.mainVStack)
        infoHStack.backgroundColor = .clear //.orange
        ADD_SPACER(to: infoHStack, width: 7)
        let infoVStack = VSTACK(into: infoHStack)
        infoVStack.backgroundColor = .clear //.blue
        ADD_SPACER(to: infoHStack, width: 7)

        self.titleLabel.backgroundColor = .clear //.orange.withAlphaComponent(0.3)
        self.titleLabel.textColor = UIColor(hex: 0x1D242F)
        infoVStack.addArrangedSubview(self.titleLabel)
        ADD_SPACER(to: infoVStack, height: 10)
        infoVStack.addArrangedSubview(self.sourcesContainer)
        ADD_SPACER(to: infoVStack, height: 10)
        
        let updateHStack = HSTACK(into: infoVStack)
        updateHStack.spacing = 5.0
        
        self.timeLabel.text = "Updated 2 hours ago"
        self.timeLabel.textColor = UIColor(hex: 0x1D242F)
        self.timeLabel.backgroundColor = .clear //.red
        self.timeLabel.font = roboto
        self.timeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        updateHStack.addArrangedSubview(self.timeLabel)
        
        let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
        updateHStack.addArrangedSubview(arrow)
        arrow.activateConstraints([
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 18)
        ])
        ADD_SPACER(to: updateHStack)
        
        ADD_SPACER(to: infoVStack, height: 12)
    }

    func populate(with story: MainFeedArticle, column: Int) {
        self.column = column
        
        self.titleLabel.text =  story.title
        if( READ(LocalKeys.preferences.showSourceIcons) == "01" ) {
            ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
        } else {
            ADD_SOURCE_ICONS(data: [], to: self.sourcesContainer)
        }
        self.timeLabel.text = story.time
    
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainVStack.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        
        self.storyLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.storyLabel.backgroundColor = DARK_MODE() ? UIColor(hex: 0xFF643C) : .white
    }
    
}

// MARK: - Cell height
extension StoryCT_cell {

    static func createTitleLabel(text: String) -> UILabel {
        let result = UILabel()
        result.numberOfLines = 10
        result.font = StoryCI_cell.merriweather_bold
        result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        result.text = text
        
        return result
    }
    
    static func calculateHeight(text: String, sourcesCount: Int, width: CGFloat) -> CGSize {
        let textW: CGFloat = (width/2)-(16*2)-(7*2)
        let tmpTitleLabel = StoryCI_cell.createTitleLabel(text: text)
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        let sourcesH: CGFloat = sourcesCount == 1 ? 0 : 18
        let timeLabelH: CGFloat = 18
        
        let H: CGFloat = 16 + 40 + textH + 10 + sourcesH + 10 + timeLabelH + 12 + 16
        return CGSize(width: width/2, height: H)
    }
    
}


