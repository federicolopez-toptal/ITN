//
//  ArticleHImageView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 23/02/2023.
//

import UIKit
import SDWebImage


class ArticleHImageView: CustomCellView {

    private var article: MainFeedArticle!

    let titleLabel = ARTICLE_TITLE()
    let mainImageView = ARTICLE_IMG()
    
    // Article
    var articleSourceRow: UIStackView? = nil
        var articleSource: UIStackView? = nil
        var articleSourceTime = UILabel()
        let stanceIcon = StanceIconView()
        
        
    
    // MARK: - Start
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildContent() {
        self.addSubview(self.mainImageView)
        self.mainImageView.activateConstraints([
            self.mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.widthAnchor.constraint(equalToConstant: 135),
            self.mainImageView.heightAnchor.constraint(equalToConstant: 85)
        ])
        
        let vStack = VSTACK(into: self)
        vStack.backgroundColor = .clear //.green.withAlphaComponent(0.3)
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: IPAD_INNER_MARGIN),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        vStack.addArrangedSubview(self.titleLabel)
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
        
        ADD_SPACER(to: vStack, height: IPAD_INNER_MARGIN)
        self.articleSourceRow = HSTACK(into: vStack)
        self.articleSourceRow!.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.articleSourceRow!.activateConstraints([
            self.articleSourceRow!.heightAnchor.constraint(equalToConstant: 28)
        ])

            self.articleSource = HSTACK(into: self.articleSourceRow!)
            self.articleSource!.backgroundColor = .clear //.orange

            self.articleSourceTime.text = "sourceName - 10 minutes ago"
            self.articleSourceTime.textColor = UIColor(hex: 0x1D242F)
            self.articleSourceTime.font = ROBOTO(13)
            self.articleSourceTime.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
            self.articleSourceRow!.addArrangedSubview(self.articleSourceTime)

            ADD_SPACER(to: self.articleSourceRow!, width: 8)
            self.articleSourceRow!.addArrangedSubview(self.stanceIcon)
            self.stanceIcon.delegate = self
            ADD_SPACER(to: self.articleSourceRow!)
            
        // -----------------
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewOnTap(_ gesture: UITapGestureRecognizer) {
        if(article.isStory) {
            let vc = StoryViewController()
            vc.story = self.article
            CustomNavController.shared.pushViewController(vc, animated: true)
        } else {
            let vc = ArticleViewController()
            vc.article = self.article
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: Overrides
    override func populate(_ article: MainFeedArticle) {
        self.article = article
        
        self.mainImageView.image = nil
        if let _url = URL(string: article.imgUrl) {
            self.mainImageView.sd_setImage(with: _url)
        }
        self.titleLabel.text = article.title
        
        if(!article.isStory) {
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: article.source) {
                sourcesArray.append(_identifier)
            }
            
            if(PREFS_SHOW_SOURCE_ICONS()) {
                ADD_SOURCE_ICONS(data: sourcesArray, to: self.articleSource!, containerHeight: 28)
            } else {
                ADD_SOURCE_ICONS(data: [], to: self.articleSource!, containerHeight: 28)
            }
            
            self.articleSourceTime.text = CLEAN_SOURCE(from: article.source) + " • " + article.time
            self.stanceIcon.setValues(article.LR, article.PE)
        }
        
        self.refreshDisplayMode()
        self.show()
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.articleSourceTime.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        
        //self.backgroundColor = .systemPink
    }

}

extension ArticleHImageView: StanceIconViewDelegate {
    func onStanceIconTap(sender: StanceIconView) {
        let info: [String : Any] = [
            "LR": self.article.LR,
            "PE": self.article.PE,
            "source": CLEAN_SOURCE(from: self.article.source),
            "country": self.article.country
        ]
        NOTIFY(Notification_stanceIconTap, userInfo: info)
    }
}
