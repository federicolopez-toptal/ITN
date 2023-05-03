//
//  ArticleCI_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 21/09/2022.
//

import UIKit

protocol ArticleCI_cell_Delegate: AnyObject {
    func onStanceIconTap(sender: ArticleCI_cell)
}

class ArticleCI_cell: UICollectionViewCell {
    
    static let identifier = "ArticleCI_cell"
    static let merriweather_bold = MERRIWEATHER_BOLD(13)
    var column: Int = 1
    weak var delegate: ArticleCI_cell_Delegate?
    
    var mainVStack: UIStackView!
    let mainImageView = UIImageView()
    let titleLabel = ArticleCI_cell.createTitleLabel(text: "Lorem ipsum")
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let stanceIcon = StanceIconView()
    let flagImageView = UIImageView()
    
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
        let roboto = ROBOTO(13)
    
        self.mainVStack = VSTACK(into: self.contentView)
        self.mainVStack.backgroundColor = .green
        self.mainVStack.activateConstraints([
            self.mainVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.mainVStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.mainVStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16+5)
        ])

        self.mainImageView.backgroundColor = .gray
        self.mainVStack.addArrangedSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        ADD_SPACER(to: self.mainVStack, height: 10)

        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = UIColor(hex: 0x1D242F)
        self.mainVStack.addArrangedSubview(self.titleLabel)
        ADD_SPACER(to: self.mainVStack, height: 10)

        let sourcesHStack = HSTACK(into: self.mainVStack)
        sourcesHStack.activateConstraints([
            sourcesHStack.heightAnchor.constraint(equalToConstant: 28)
        ])
        sourcesHStack.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)

        self.flagImageView.backgroundColor = .clear
        self.flagImageView.activateConstraints([
            self.flagImageView.widthAnchor.constraint(equalToConstant: 18),
            self.flagImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        let flagVStack = VSTACK(into: sourcesHStack)
        ADD_SPACER(to: flagVStack, height: 5)
        flagVStack.addArrangedSubview(self.flagImageView)
        ADD_SPACER(to: flagVStack, height: 5)
        
        ADD_SPACER(to: sourcesHStack, width: 6)

        sourcesHStack.addArrangedSubview(self.sourcesContainer)

        self.sourceTimeLabel.text = "Last updated 2 hours ago"
        self.sourceTimeLabel.textColor = .black
        self.sourceTimeLabel.numberOfLines = 2
        self.sourceTimeLabel.font = roboto
        self.sourceTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
        sourcesHStack.addArrangedSubview(self.sourceTimeLabel)

        ADD_SPACER(to: sourcesHStack, width: 5)
        sourcesHStack.addArrangedSubview(self.stanceIcon)
        self.stanceIcon.alpha = 1.0
        if(PREFS_SHOW_STANCE_ICONS()==false) {
            self.stanceIcon.alpha = 0
        }
        self.stanceIcon.delegate = nil
        if(PREFS_SHOW_STANCE_POPUPS()) {
            self.stanceIcon.delegate = self
        }
        //ADD_SPACER(to: sourcesHStack)

        ADD_SPACER(to: self.mainVStack, height: 16)        
    }

    func populate(with article: MainFeedArticle, column: Int) {
        self.column = column
    
        self.mainImageView.image = nil
        if let _url = URL(string: article.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }
        
        self.titleLabel.text = article.title
        self.titleLabel.setLineSpacing(lineSpacing: 3.5)
        
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: article.source) {
            sourcesArray.append(_identifier)
        }
        if( READ(LocalKeys.preferences.showSourceIcons) == "01" ) {
            ADD_SOURCE_ICONS(data: sourcesArray, to: self.sourcesContainer, containerHeight: 28)
        } else {
            ADD_SOURCE_ICONS(data: [], to: self.sourcesContainer, containerHeight: 28)
        }
        
        var source = article.source
        if let _cleanSource = source.components(separatedBy: " #").first {
            source = _cleanSource
        }
        self.sourceTimeLabel.text = source + " • " + self.shortenTime(article.time)
        self.stanceIcon.setValues(article.LR, article.PE)

        self.refreshDisplayMode()
        
        
        self.LR = article.LR
        self.PE = article.PE
        self.sourceName = source
        self.country = article.country
        
        if let _image = UIImage(named: self.country.uppercased() + "64.png") {
            self.flagImageView.image = _image
        } else {
            self.flagImageView.image = UIImage(named: "noFlag.png")
        }
        
        // ----------------
        var alphaValue: CGFloat = 1.0
        if(article.isEmpty()){ alphaValue = 0.0 }
    
        self.mainImageView.alpha = alphaValue
        self.titleLabel.alpha = alphaValue
        self.stanceIcon.alpha = alphaValue
        self.sourceTimeLabel.alpha = alphaValue
        self.sourcesContainer.alpha = alphaValue
        self.flagImageView.alpha = alphaValue
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
        self.stanceIcon.refreshDisplayMode()
    }
}

// MARK: - Cell height
extension ArticleCI_cell {

    static func createTitleLabel(text: String) -> UILabel {
        let result = UILabel()
        result.numberOfLines = 0
        result.font = ArticleCI_cell.merriweather_bold
        //result.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
        result.text = text
        
        return result
    }
    
    static func calculateHeight(text: String, sourcesCount: Int, width: CGFloat) -> CGSize {
        let imageH: CGFloat = 100
        let textW: CGFloat = (width/2)-(16*2)
        let tmpTitleLabel = ArticleCI_cell.createTitleLabel(text: text)
        tmpTitleLabel.setLineSpacing(lineSpacing: 3.5)
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        let sourcesH: CGFloat = 28
        
        var H: CGFloat = 16+5 + imageH + 10 + textH + 10 + sourcesH + 16
//        let minH: CGFloat = 260
//        if(H<minH){ H = minH }
        
        return CGSize(width: width/2, height: H)
    }
    
}

extension ArticleCI_cell: StanceIconViewDelegate {
    
    func onStanceIconTap(sender: StanceIconView) {
        self.delegate?.onStanceIconTap(sender: self)
    }
    
}
