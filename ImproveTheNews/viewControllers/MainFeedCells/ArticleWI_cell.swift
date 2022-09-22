//
//  ArticleWI_cell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

class ArticleWI_cell: UICollectionViewCell {

    static let identifier = "ArticleWI_cell"
    //private let HEIGHT: CGFloat = 1.0     Height based on content!
    private let WIDTH: CGFloat = SCREEN_SIZE().width

    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: self.WIDTH)
        width.isActive = true
        return width
    }()
    
    let mainImageView = UIImageView()
    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let sourceTimeLabel = UILabel()
    let bottomLine = UIView()
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
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        width.constant = self.WIDTH
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

}

extension ArticleWI_cell {
    
    private func buildContent() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //self.contentView.heightAnchor.constraint(equalToConstant: self.HEIGHT)
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
        
        let mainHStack = HSTACK(into: self.contentView, spacing: 16)
        mainHStack.backgroundColor = .clear //.cyan
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            mainHStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16) // cell height
        ])
        
        let imageVStack = VSTACK(into: mainHStack)
        imageVStack.backgroundColor = .clear
        
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
        titleVStack.backgroundColor = .clear //.orange

    let merriweather_bold = UIFont(name: "Merriweather-Bold", size: 16)
    let roboto = UIFont(name: "Roboto-Regular", size: 13)

        self.titleLabel.backgroundColor = .clear //.yellow
        self.titleLabel.textColor = .black
        self.titleLabel.numberOfLines = 4
        self.titleLabel.font = merriweather_bold
        self.titleLabel.text = "Test title"
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.65)
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
        self.stanceIcon.delegate = self
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
    }
    
    func refreshDisplayMode() {
        self.contentView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.mainImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.15) : .lightGray
        
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.sourceTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.stanceIcon.refreshDisplayMode()
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }
    
}

extension ArticleWI_cell: StanceIconViewDelegate {
    
    func onStanceIconTap(sender: StanceIconView) {
        // https://www.figma.com/file/2trQtjl1kAFZOspiVF3RNp/Card%2C-Feed-%26-Navigation?node-id=3516%3A115608
        
        print("HERE!")
    }
    
}
