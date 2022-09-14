//
//  WideArticleCell.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 13/09/2022.
//

import UIKit

class WideArticleCell: UITableViewCell {

    static let identifier = "WideArticleCell"
    static let heigth: CGFloat = 130

    let mainImageView = UIImageView()
    let titleLabel = UILabel()
    let sourcesContainer = UIStackView()
    let timeLabel = UILabel()
    let bottomLine = UIView()
    

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

extension WideArticleCell {
    
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
        
        let mainHStack = UIStackView()
        mainHStack.axis = .horizontal
        mainHStack.spacing = 16
        mainHStack.backgroundColor = .clear //.cyan
        self.addSubview(mainHStack)
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            mainHStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
            
            //mainHStack.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        let imageVStack = UIStackView()
        imageVStack.axis = .vertical
        imageVStack.backgroundColor = .clear //.cyan
        mainHStack.addArrangedSubview(imageVStack)
        
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

        let titleVStack = UIStackView()
        titleVStack.axis = .vertical
        titleVStack.spacing = 13
        titleVStack.backgroundColor = .clear //.cyan
        mainHStack.addArrangedSubview(titleVStack)

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
        
        self.timeLabel.text = "Last updated 2 hours ago"
        self.timeLabel.textColor = .black
        self.timeLabel.font = roboto
        iconsHStack.addArrangedSubview(self.timeLabel)
        
        ADD_SPACER(to: titleVStack)
    }
    
    func populate(with story: MainFeedArticle) {
        self.mainImageView.image = nil
        if let _url = URL(string: story.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }
        
        self.titleLabel.text = story.title
        ADD_SOURCE_ICONS(data: story.storySources, to: self.sourcesContainer)
        
        var mText = story.time
        mText = mText.replacingOccurrences(of: " ago", with: "")
        mText = mText.replacingOccurrences(of: " minute", with: "m")
        mText = mText.replacingOccurrences(of: " hour", with: "h")
        mText = mText.replacingOccurrences(of: " day", with: "d")
        self.timeLabel.text = mText
        
        self.refreshDisplayMode()
    }
    
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.timeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.bottomLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E2634) : UIColor(hex: 0xE2E3E3)
    }
    
}
