//
//  WideArticleCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

class ArticleCell: UITableViewCell {

    static let identifier = "ArticleCell"

    let mainImageView = UIImageView()
    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let bottomLine = UIView()
    let stanceIcon = StanceIconView()
    

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

extension ArticleCell {
    
    private func buildContent() {
        self.backgroundColor = .white
        
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = .black
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        let mainHStack = HSTACK(into: self, spacing: 16)
        mainHStack.backgroundColor = .clear //.cyan
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainHStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
            //mainHStack.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        let imageVStack = VSTACK(into: mainHStack)
        imageVStack.backgroundColor = .clear //.cyan
        
        self.mainImageView.backgroundColor = .darkGray
        imageVStack.addArrangedSubview(self.mainImageView)
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mainImageView.widthAnchor.constraint(equalToConstant: 112),
            self.mainImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        ADD_SPACER(to: imageVStack)

        let titleVStack = VSTACK(into: mainHStack, spacing: 13)
        titleVStack.backgroundColor = .clear //.cyan

    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 16)
    let roboto = UIFont(name: "Roboto-Regular", size: 13)

        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = .black
        self.titleLabel.numberOfLines = 4
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Test title"
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.65
        titleVStack.addArrangedSubview(self.titleLabel)
        
        let iconsHStack = HSTACK(into: titleVStack)
        iconsHStack.addArrangedSubview(self.sourcesContainer)
        
        self.sourceTimeLabel.text = "Last updated 2 hours ago"
        self.sourceTimeLabel.textColor = .black
        self.sourceTimeLabel.font = roboto
        iconsHStack.addArrangedSubview(self.sourceTimeLabel)
        
        ADD_SPACER(to: iconsHStack, width: 10)
        iconsHStack.addArrangedSubview(self.stanceIcon)
        ADD_SPACER(to: iconsHStack)
        
        ADD_SPACER(to: titleVStack)
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
        ADD_SOURCE_ICONS(data: sourcesArray, to: self.sourcesContainer)
        
        var source = article.source
        if let _cleanSource = source.components(separatedBy: " #").first {
            source = _cleanSource
        }
        self.sourceTimeLabel.text = source + " • " + article.time
        
        self.stanceIcon.setValues(article.LR, article.PE)
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sourceTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.stanceIcon.refreshDisplayMode()
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }
    
}
