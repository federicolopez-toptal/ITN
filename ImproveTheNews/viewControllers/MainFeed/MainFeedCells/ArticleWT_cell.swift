//
//  ArticleWT_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 15/09/2022.
//

import UIKit

protocol ArticleWT_cell_Delegate {
    func onStanceIconTap(sender: ArticleWT_cell)
}

class ArticleWT_cell: UICollectionViewCell {

    static let identifier = "ArticleWT_cell"
    static let merriweather_bold = MERRIWEATHER_BOLD(17)
    var delegate: ArticleWT_cell_Delegate?

    let titleLabel = ArticleWT_cell.createTitleLabel(text: "Lorem ipsum")
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let stanceIcon = StanceIconView()
    let bottomLine = UIView()
    
    var LR: Int = 1
    var PE: Int = 1
    var sourceName: String = ""
    var country: String = ""


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
        
        self.contentView.addSubview(bottomLine)
        bottomLine.backgroundColor = .black
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
    let roboto = ROBOTO(13)
    
        self.titleLabel.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)
        self.titleLabel.textColor = .black
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        ])
        
        let iconsHStack = HSTACK(into: self.contentView)
        iconsHStack.backgroundColor = .clear //.cyan.withAlphaComponent(0.3)
        iconsHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconsHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            iconsHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            iconsHStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10)
        ])
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.sourceTimeLabel.text = "Last updated 2 hours ago"
        self.sourceTimeLabel.textColor = .black
        self.sourceTimeLabel.font = roboto
        self.sourceTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        iconsHStack.addArrangedSubview(self.sourceTimeLabel)
        
        ADD_SPACER(to: iconsHStack, width: 10)
        iconsHStack.addArrangedSubview(self.stanceIcon)
        self.stanceIcon.delegate = self
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
        
        
        self.LR = article.LR
        self.PE = article.PE
        self.sourceName = source
        self.country = article.country
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sourceTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.stanceIcon.refreshDisplayMode()
    }
    
    
    
    static func createTitleLabel(text: String) -> UILabel {
        let result = UILabel()
        result.numberOfLines = 4
        result.font = ArticleWT_cell.merriweather_bold
        result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        result.text = text
        
        return result
    }
    
    static func calculateHeight(text: String, width: CGFloat) -> CGSize {
        let textW: CGFloat = width-(16*2)
        let tmpTitleLabel = ArticleWT_cell.createTitleLabel(text: text)
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        let sourcesH: CGFloat = 28
        
        let H: CGFloat = 16 + textH + 10 + sourcesH + 16
        return CGSize(width: width, height: H)
    }
    
}

extension ArticleWT_cell: StanceIconViewDelegate {
    
    func onStanceIconTap(sender: StanceIconView) {
        self.delegate?.onStanceIconTap(sender: self)
    }
    
}
