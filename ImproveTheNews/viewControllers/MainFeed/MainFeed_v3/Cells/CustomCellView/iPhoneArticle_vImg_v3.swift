//
//  iPhoneArticle_vImg_v3.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 02/11/2023.
//

import Foundation
import UIKit
import SDWebImage

class iPhoneArticle_vImg_v3: CustomCellView_v3 {

    private let imgWidth: CGFloat = 160
    private let imgHeight: CGFloat = 88
    private var WIDTH: CGFloat = 1
    
    let mainImageView = CustomImageView(showCorners: false)
    let titleLabel = UILabel()
    let sources = SourceIconsView()
    let sourceLabel = UILabel()
    let timeLabel = UILabel()
    
    var article: MainFeedArticle!
    
    // MARK: - Start
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.WIDTH = width
        self.buildContent()
    }
    
    private func calculateImageViewHeight() -> CGFloat {
        let H = (self.WIDTH * imgHeight)/imgWidth
        return H
    }
    
    private func buildContent() {

        self.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.widthAnchor.constraint(equalToConstant: self.WIDTH),
            self.mainImageView.heightAnchor.constraint(equalToConstant: self.calculateImageViewHeight())
        ])
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = CSS.shared.iPhoneArticle_titleFont
        self.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: CSS.shared.iPhoneSide_padding),
        ])
        
        self.sources.buildInto(self)
        self.sources.activateConstraints([
            self.sources.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.sources.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: CSS.shared.iPhoneSide_padding)
        ])
        
        self.timeLabel.font = CSS.shared.iPhoneArticle_textFont
        self.timeLabel.textAlignment = .left
        self.addSubview(self.timeLabel)
        self.timeLabel.activateConstraints([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.sources.centerYAnchor),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.sourceLabel.font = CSS.shared.iPhoneArticle_textFont
        self.sourceLabel.numberOfLines = 0
        self.sourceLabel.textAlignment = .left
        self.addSubview(self.sourceLabel)
        self.sourceLabel.activateConstraints([
            self.sourceLabel.centerYAnchor.constraint(equalTo: self.sources.centerYAnchor),
            self.sourceLabel.leadingAnchor.constraint(equalTo: self.sources.trailingAnchor, constant: 5),
            self.sourceLabel.trailingAnchor.constraint(equalTo: self.timeLabel.leadingAnchor, constant: -10)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
        
        self.refreshDisplayMode()
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article
        
        var sourcesArray = [String]()
        if let _identifier = Sources.shared.search(name: article.source) {
            sourcesArray.append(_identifier)
        }
        
        self.mainImageView.load(url: article.imgUrl)
        self.titleLabel.text = article.title
        self.sources.load(sourcesArray)
        self.sourceLabel.text = CLEAN_SOURCE(from: article.source).uppercased()
        self.timeLabel.text = SHORT_TIME(input: article.time)
    }
    
    override func refreshDisplayMode() {
        self.titleLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.sources.refreshDisplayMode()
        self.sourceLabel.textColor = CSS.shared.displayMode().main_textColor
        self.timeLabel.textColor = CSS.shared.displayMode().main_textColor
    }
    
    // MARK: misc
    func calculateHeight() -> CGFloat {
        return self.calculateImageViewHeight() + CSS.shared.iPhoneSide_padding +
                self.titleLabel.calculateHeightFor(width: self.WIDTH) + CSS.shared.iPhoneSide_padding +
                24 + 32
    }
    
    // MARK: Actions
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        CustomNavController.shared.tour?.cancel()
        
        if let _article = self.article {
            if(_article.isEmpty()) { return }
            
            if(!_article.isStory) {
                let vc = ArticleViewController()
                vc.article = article
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
        }
    }
    
}
