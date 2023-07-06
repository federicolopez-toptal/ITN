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
        let flagImageView = UIImageView()
        
    
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
        
        self.titleLabel.font = IPHONE() ? MERRIWEATHER_BOLD(13) : MERRIWEATHER_BOLD(20)
        vStack.addArrangedSubview(self.titleLabel)
        //self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
        
        ADD_SPACER(to: vStack, height: IPAD_INNER_MARGIN)
        self.articleSourceRow = HSTACK(into: vStack)
        self.articleSourceRow!.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.articleSourceRow!.activateConstraints([
            self.articleSourceRow!.heightAnchor.constraint(equalToConstant: 28)
        ])

            self.flagImageView.backgroundColor = .clear
            self.flagImageView.activateConstraints([
                self.flagImageView.widthAnchor.constraint(equalToConstant: 18),
                self.flagImageView.heightAnchor.constraint(equalToConstant: 18)
            ])
            let flagVStack = VSTACK(into: self.articleSourceRow!)
            ADD_SPACER(to: flagVStack, height: 5)
            flagVStack.addArrangedSubview(self.flagImageView)
            ADD_SPACER(to: flagVStack, height: 5)
            ADD_SPACER(to: self.articleSourceRow!, width: 6)

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
        CustomNavController.shared.tour?.cancel()
        if(article.isEmpty()){ return }
        
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
        
        //print("article.imgUrl", article.imgUrl)
        
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
            
            if(PREFS_SHOW_FLAGS()) {
                self.flagImageView.superview!.show()
            } else {
                self.flagImageView.superview!.hide()
            }
        }
        
        if let _image = UIImage(named: self.article.country.uppercased() + "64.png") {
            self.flagImageView.image = _image
        } else {
            self.flagImageView.image = UIImage(named: "noFlag.png")
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
    
    static func calculateHeight(text: String, width: CGFloat) -> CGFloat {
        let tmpTitleLabel = ARTICLE_TITLE()
        tmpTitleLabel.font = IPHONE() ? MERRIWEATHER_BOLD(13) : MERRIWEATHER_BOLD(20)
        tmpTitleLabel.text = text
        //tmpTitleLabel.font = MERRIWEATHER_BOLD(30)
        let textW: CGFloat = width - 135 - IPAD_INNER_MARGIN
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        
        return textH + 28 + (IPAD_INNER_MARGIN * 2)
    }
}


// MARK: - highlight search text
extension ArticleHImageView {

    func highlight(subtext: String) {
        let T = self.article.title.lowercased()
        let font = self.titleLabel.font
        self.titleLabel.attributedText = self.prettifyText(fullString: self.article.title as NSString,
            boldPartsOfString: [], font: font, boldFont: font, paths: [], linkedSubstrings: [], accented: [subtext])        
    }
    
    private func prettifyText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!, paths: [String], linkedSubstrings: [String], accented: [String]) -> NSAttributedString {

        let nonBoldFontAttribute: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font:font!, NSAttributedString.Key.foregroundColor: DARK_MODE() ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x1D242F)]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let accentedAttribute:  [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xF3643C)]
        
        
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        for l in 0..<paths.count {
            let sbstrRange = fullString.range(of: linkedSubstrings[l])
            boldString.addAttribute(.link, value: paths[l], range: sbstrRange)
        }
        for a in 0..<accented.count {
            let sbstrRange = fullString.range(of: accented[a], options: .caseInsensitive)
            
            boldString.addAttributes(accentedAttribute, range: sbstrRange)
        }
        return boldString
    }

}
