//
//  ArticleWT_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/09/2022.
//

import UIKit

class ArticleWT_cell: UICollectionViewCell {

    static let identifier = "ArticleWT_cell"
    //private let HEIGHT: CGFloat = 0.0     Height based on content!

    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let stanceIcon = StanceIconView()
    let bottomLine = UIView()
    


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
        
        let targetSize = CGSize(width: SCREEN_SIZE().width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
        
        return layoutAttributes
    }
    
}
 
extension ArticleWT_cell {

    private func buildContent() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //self.contentView.heightAnchor.constraint(equalToConstant: self.HEIGHT)
            self.contentView.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width)
        ])
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(bottomLine)
        bottomLine.backgroundColor = .black
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 17)
    let roboto = UIFont(name: "Roboto-Regular", size: 13)
    
        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = .black
        self.titleLabel.numberOfLines = 3
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Test title"
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        ])
        
        let iconsHStack = HSTACK(into: self.contentView)
        iconsHStack.backgroundColor = .clear //.orange
        iconsHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconsHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            iconsHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            iconsHStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            iconsHStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16) // cell height
        ])
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.sourceTimeLabel.text = "Last updated 2 hours ago"
        self.sourceTimeLabel.textColor = .black
        self.sourceTimeLabel.font = roboto
        self.sourceTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        iconsHStack.addArrangedSubview(self.sourceTimeLabel)
        
        ADD_SPACER(to: iconsHStack, width: 10)
        iconsHStack.addArrangedSubview(self.stanceIcon)
        ADD_SPACER(to: iconsHStack)
    }


    func populate(with article: MainFeedArticle) {
        self.titleLabel.text = article.title
        
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: article.source) {
            sourcesArray.append(_identifier)
        }
        ADD_SOURCE_ICONS(data: sourcesArray, to: self.sourcesContainer, containerHeight: 28)
        
        var source = article.source
        if let _cleanSource = source.components(separatedBy: " #").first {
            source = _cleanSource
        }
        self.sourceTimeLabel.text = source + " • " + article.time
        
        self.stanceIcon.setValues(article.LR, article.PE)
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sourceTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.stanceIcon.refreshDisplayMode()
    }
    
}
