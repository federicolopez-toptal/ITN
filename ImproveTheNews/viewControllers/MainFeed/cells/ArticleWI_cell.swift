//
//  ArticleWI_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

protocol ArticleWI_cell_Delegate: AnyObject {
    func onStanceIconTap(sender: ArticleWI_cell)
}

class ArticleWI_cell: UICollectionViewCell {

    static let identifier = "ArticleWI_cell"
    static let merriweather_bold = MERRIWEATHER_BOLD(16)
    weak var delegate: ArticleWI_cell_Delegate?
    
    let mainImageView = UIImageView()
    let titleLabel = ArticleWI_cell.createTitleLabel(text: "Lorem ipsum")
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let bottomLine = UIView()
    let stanceIcon = StanceIconView()

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
        bottomLine.activateConstraints([
            bottomLine.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        let mainHStack = HSTACK(into: self.contentView, spacing: 16)
        mainHStack.backgroundColor = .clear //.purple
        mainHStack.activateConstraints([
            mainHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            mainHStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16)
        ])
        
        let imageVStack = VSTACK(into: mainHStack)
        imageVStack.backgroundColor = .clear
        
        self.mainImageView.backgroundColor = .darkGray
        imageVStack.addArrangedSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.widthAnchor.constraint(equalToConstant: 112),
            self.mainImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        ADD_SPACER(to: imageVStack)

        let titleVStack = VSTACK(into: mainHStack, spacing: 13)
        titleVStack.backgroundColor = .clear //.orange

    let roboto = ROBOTO(13)

        self.titleLabel.backgroundColor = .clear //.yellow.withAlphaComponent(0.2)
        self.titleLabel.textColor = .black
        titleVStack.addArrangedSubview(self.titleLabel)
        
        let iconsHStack = HSTACK(into: titleVStack)
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.sourceTimeLabel.text = "Last updated 2 hours ago"
        self.sourceTimeLabel.textColor = .black
        self.sourceTimeLabel.font = roboto
        self.sourceTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        iconsHStack.addArrangedSubview(self.sourceTimeLabel)
        
        ADD_SPACER(to: iconsHStack, width: 10)
        iconsHStack.addArrangedSubview(self.stanceIcon)
        
        self.stanceIcon.alpha = 1.0
        if(READ(LocalKeys.preferences.showStanceIcons)=="00") {
            self.stanceIcon.alpha = 0
        }
        self.stanceIcon.delegate = nil
        if(READ(LocalKeys.preferences.showStancePopups)=="01") {
            self.stanceIcon.delegate = self
        }
        
        ADD_SPACER(to: iconsHStack)
        
        //ADD_SPACER(to: titleVStack)
    }
    
    func populate(with article: MainFeedArticle) {
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
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sourceTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.stanceIcon.refreshDisplayMode()
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }
    
    static func createTitleLabel(text: String) -> UILabel {
        let result = UILabel()
        result.numberOfLines = 4
        result.font = ArticleWI_cell.merriweather_bold
        result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        result.text = text
        
        return result
    }
    
    static func calculateHeight(text: String, width: CGFloat) -> CGSize {
        let imageW: CGFloat = 112
        let textW: CGFloat = width-(16*3)-imageW
        let tmpTitleLabel = ArticleWI_cell.createTitleLabel(text: text)
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        let sourcesH: CGFloat = 28
        
        let H: CGFloat = 16 + textH + 13 + sourcesH + 16
        return CGSize(width: width, height: H)
    }
    
}

extension ArticleWI_cell: StanceIconViewDelegate {
    
    // https://www.figma.com/file/2trQtjl1kAFZOspiVF3RNp/Card%2C-Feed-%26-Navigation?node-id=3516%3A115608
    func onStanceIconTap(sender: StanceIconView) {
        self.delegate?.onStanceIconTap(sender: self)
    }
    
}
