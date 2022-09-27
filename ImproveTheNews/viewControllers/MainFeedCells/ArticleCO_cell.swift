//
//  ArticleCO_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/09/2022.
//

import UIKit

class ArticleCO_cell: UICollectionViewCell {
    
    static let identifier = "ArticleCO_cell"
    //private let HEIGHT: CGFloat = 1.0     Height based on content!
    var column: Int = 1
    
    var mainVStack: UIStackView!
    let mainImageView = UIImageView()
    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let stanceIcon = StanceIconView()
    
    
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

extension ArticleCO_cell {

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
    
        self.mainVStack = VSTACK(into: self.contentView)
        self.mainVStack.backgroundColor = .green
        self.mainVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
        ADD_SPACER(to: self.mainVStack, height: 10)

        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = UIColor(hex: 0x1D242F)
        self.titleLabel.numberOfLines = 5
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Vaccine required for NHS health care workers"
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        self.mainVStack.addArrangedSubview(self.titleLabel)
        ADD_SPACER(to: self.mainVStack, height: 10)
        
        let sourcesHStack = HSTACK(into: self.mainVStack)
        sourcesHStack.backgroundColor = .clear //.yellow
        
        sourcesHStack.addArrangedSubview(self.sourcesContainer)
        
        self.sourceTimeLabel.text = "Last updated 2 hours ago"
        self.sourceTimeLabel.textColor = .black
        self.sourceTimeLabel.font = roboto
        self.sourceTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        sourcesHStack.addArrangedSubview(self.sourceTimeLabel)
        
        ADD_SPACER(to: sourcesHStack, width: 5)
        sourcesHStack.addArrangedSubview(self.stanceIcon)
        ADD_SPACER(to: sourcesHStack)
        
        ADD_SPACER(to: self.mainVStack, height: 10)
    }

    func populate(with article: MainFeedArticle, column: Int) {
        self.column = column
    
        self.mainImageView.image = nil
        if let _url = URL(string: article.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }

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
        self.sourceTimeLabel.text = source + " • " + self.shortenTime(article.time)
        self.stanceIcon.setValues(article.LR, article.PE)
        
        self.refreshDisplayMode()
    }
    
    private func shortenTime(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: " ago", with: "")
        
        return result
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainVStack.backgroundColor = self.contentView.backgroundColor
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sourceTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
    }
}
