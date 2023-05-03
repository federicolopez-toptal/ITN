//
//  ArticleBigTextView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 28/02/2023.
//

import UIKit

class ArticleBigTextView: CustomCellView {

    private var article: MainFeedArticle!

    let pill = STORY_PILL()
    let spacer = UIView()
    let titleLabel = ARTICLE_TITLE()
    
    var spacerHeightConstraint: NSLayoutConstraint?
    var vStackLeadingConstraint: NSLayoutConstraint?
    var vStackTrailingConstraint: NSLayoutConstraint?
    var vStackTopConstraint: NSLayoutConstraint?
    
    
    // Story
    var storySourcesRow: UIStackView? = nil
        var storySources: UIStackView? = nil
        let storyTimeLabel = UILabel()
    
    // Article
    var articleSourceRow: UIStackView? = nil
        var articleSource: UIStackView? = nil
        var articleSourceTime = UILabel()
        let stanceIcon = StanceIconView()
        let flagImageView = UIImageView()
        
    var sourcesLimit: Int = 6
        
        
    
    // MARK: - Start
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.buildContent()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFontSize(_ size: CGFloat) {
        self.titleLabel.font = MERRIWEATHER_BOLD(size)
    }
    
    func setSourcesLimit(_ limit: Int) {
        self.sourcesLimit = limit
    }
    
    private func buildContent() {
        let vStack = VSTACK(into: self)
        vStack.backgroundColor = .clear //.green.withAlphaComponent(0.3)
        self.vStackLeadingConstraint = vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IPAD_INNER_MARGIN)
        self.vStackTrailingConstraint = vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -IPAD_INNER_MARGIN)
        self.vStackTopConstraint = vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: IPAD_INNER_MARGIN)
        vStack.activateConstraints([
            self.vStackLeadingConstraint!,
            self.vStackTrailingConstraint!,
            self.vStackTopConstraint!
        ])
        
        vStack.addSubview(self.pill)
        self.pill.activateConstraints([
            self.pill.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            self.pill.topAnchor.constraint(equalTo: vStack.topAnchor)
        ])
        
        self.spacer.backgroundColor = .clear
        vStack.addArrangedSubview(self.spacer)
        self.spacerHeightConstraint = self.spacer.heightAnchor.constraint(equalToConstant: 0)
        self.spacer.activateConstraints([
            self.spacerHeightConstraint!
        ])

        vStack.addArrangedSubview(self.titleLabel)
        self.titleLabel.font = MERRIWEATHER_BOLD(30)
        self.titleLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.2)
    
    // STORY
        ADD_SPACER(to: vStack, height: 14)
        self.storySourcesRow = HSTACK(into: vStack)
        self.storySourcesRow!.backgroundColor = .clear //.red.withAlphaComponent(0.5)
            self.storySources = HSTACK(into: self.storySourcesRow!)
            self.storySources!.backgroundColor = .clear //.systemPink
            
            self.storyTimeLabel.text = "Last updated 2 hours ago"
            self.storyTimeLabel.textColor = UIColor(hex: 0x1D242F)
            self.storyTimeLabel.font = ROBOTO(13)
            self.storySourcesRow!.addArrangedSubview(self.storyTimeLabel)
            
            ADD_SPACER(to: self.storySourcesRow!, width: 5)
            let arrow = UIImageView(image: UIImage(named: "story.lastUpdated.arrow"))
            self.storySourcesRow!.addArrangedSubview(arrow)
            arrow.activateConstraints([
                arrow.widthAnchor.constraint(equalToConstant: 18),
                arrow.heightAnchor.constraint(equalToConstant: 18)
            ])
            ADD_SPACER(to: self.storySourcesRow!)
            
    // ARTICLE
        self.articleSourceRow = UIStackView()
        self.articleSourceRow!.axis = .horizontal
        self.articleSourceRow!.backgroundColor = .clear //.green.withAlphaComponent(0.5)
        vStack.addSubview(self.articleSourceRow!)
        self.articleSourceRow!.activateConstraints([
            self.articleSourceRow!.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 14),
            self.articleSourceRow!.leadingAnchor.constraint(equalTo: self.storySourcesRow!.leadingAnchor),
            self.articleSourceRow!.trailingAnchor.constraint(equalTo: self.storySourcesRow!.trailingAnchor),
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
        self.titleLabel.text = article.title
        
        if(article.isStory) {
            self.spacerHeightConstraint?.constant = 30
            self.vStackLeadingConstraint?.constant = IPAD_INNER_MARGIN
            self.vStackTrailingConstraint?.constant = -IPAD_INNER_MARGIN
            self.vStackTopConstraint?.constant = IPAD_INNER_MARGIN
            self.pill.alpha = 1.0
            
            if(PREFS_SHOW_SOURCE_ICONS()) {
                ADD_SOURCE_ICONS(data: article.storySources, to: self.storySources!, limit: self.sourcesLimit)
            } else {
                ADD_SOURCE_ICONS(data: [], to: self.storySources!)
            }
                
            self.storySourcesRow!.alpha = 1
            self.articleSourceRow!.alpha = 0
            
            self.storyTimeLabel.text = "Last updated " + article.time
        } else {
            self.spacerHeightConstraint?.constant = 0
            self.vStackLeadingConstraint?.constant = 0
            self.vStackTrailingConstraint?.constant = 0
            self.vStackTopConstraint?.constant = 0
            self.pill.alpha  = 0
        
            var sourcesArray = [String]()
            if let _identifier = Sources.shared.search(name: article.source) {
                sourcesArray.append(_identifier)
            }
            
            if(PREFS_SHOW_SOURCE_ICONS()) {
                ADD_SOURCE_ICONS(data: sourcesArray, to: self.articleSource!, containerHeight: 28)
            } else {
                ADD_SOURCE_ICONS(data: [], to: self.articleSource!, containerHeight: 28)
            }
            
            self.storySourcesRow!.alpha = 0
            self.articleSourceRow!.alpha = 1
            
            self.articleSourceTime.text = CLEAN_SOURCE(from: article.source) + " • " + article.time
            self.articleSourceTime.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
            self.stanceIcon.setValues(article.LR, article.PE)
        }
        
        if let _image = UIImage(named: self.article.country.uppercased() + "64.png") {
            self.flagImageView.image = _image
        } else {
            self.flagImageView.image = UIImage(named: "noFlag.png")
        }
        
        // ----------------
        var alphaValue: CGFloat = 1.0
        if(article.isEmpty()){ alphaValue = 0.0 }
    
        self.titleLabel.alpha = alphaValue
        self.stanceIcon.alpha = alphaValue
        self.articleSourceTime.alpha = alphaValue
        self.flagImageView.alpha = alphaValue
        // ----------------
        
        self.refreshDisplayMode()
        self.show()
    }
    
    override func refreshDisplayMode() {
        if(article.isStory) {
            self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1D242F) : UIColor(hex: 0xE9EAEB)
        } else {
            self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        }
        
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.storyTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.storyTimeLabel.reduceFontSizeIfNeededDownTo(scaleFactor: 0.5)
        self.articleSourceTime.textColor = self.storyTimeLabel.textColor
        //self.backgroundColor = .systemPink
    }

}

extension ArticleBigTextView: StanceIconViewDelegate {
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
        tmpTitleLabel.text = text
        let textW: CGFloat = width - 135 - IPAD_INNER_MARGIN
        let textH: CGFloat = tmpTitleLabel.calculateHeightFor(width: textW)
        
        return textH + 28 + (IPAD_INNER_MARGIN * 2)
    }
}
