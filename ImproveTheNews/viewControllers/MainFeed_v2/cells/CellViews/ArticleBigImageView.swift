//
//  ArticleBigImageView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/02/2023.
//

import UIKit
import SDWebImage


class ArticleBigImageView: CustomCellView {

    private var article: MainFeedArticle!

    let mainImageView = ARTICLE_IMG()
    let pill = STORY_PILL()
    let titleLabel = ARTICLE_TITLE()
    let gradient = UIImageView()
    let gradientBottom = UIView()
    
    // Story
    var storySourcesRow: UIStackView? = nil
        var storySources: UIStackView? = nil
        let storyTimeLabel = UILabel()
    
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
            self.mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let vStack = VSTACK(into: self)
        vStack.backgroundColor = .clear //.green.withAlphaComponent(0.3)
        vStack.activateConstraints([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: IPAD_INNER_MARGIN),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -IPAD_INNER_MARGIN),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -IPAD_INNER_MARGIN * 1.5)
        ])
        
        let hStack_pill = HSTACK(into: vStack)
        hStack_pill.addArrangedSubview(self.pill)
        ADD_SPACER(to: hStack_pill)
        
        self.gradient.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        self.addSubview(self.gradient)
        self.gradient.activateConstraints([
            self.gradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gradient.topAnchor.constraint(equalTo: self.pill.topAnchor, constant: -20),
            self.gradient.heightAnchor.constraint(equalToConstant: 80),
            self.gradient.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        self.gradient.contentMode = .scaleToFill
        self.gradient.clipsToBounds = true
        
        self.addSubview(gradientBottom)
        self.gradientBottom.activateConstraints([
            self.gradientBottom.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.gradientBottom.topAnchor.constraint(equalTo: self.gradient.bottomAnchor),
            self.gradientBottom.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.gradientBottom.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        vStack.superview?.bringSubviewToFront(vStack)
        
        ADD_SPACER(to: vStack, height: 10)
        vStack.addArrangedSubview(self.titleLabel)
    
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
        
        if(article.isStory) {
            self.pill.alpha = 1.0
            self.gradient.alpha = 1.0
            self.gradientBottom.alpha = 1.0
            
            if(PREFS_SHOW_SOURCE_ICONS()) {
                ADD_SOURCE_ICONS(data: article.storySources, to: self.storySources!)
            } else {
                ADD_SOURCE_ICONS(data: [], to: self.storySources!)
            }
            
            self.storySourcesRow!.alpha = 1
            self.articleSourceRow!.alpha = 0
            
            self.storyTimeLabel.text = "Last updated " + article.time
        } else {
            self.pill.alpha  = 0
            self.gradient.alpha = 0.8
            self.gradientBottom.alpha = 0.8
        
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
            self.stanceIcon.setValues(article.LR, article.PE)
        }
        
        self.refreshDisplayMode()
        self.show()
    }
    
    override func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.gradient.image = UIImage(named: DisplayMode.imageName("story.shortGradient"))
        self.gradientBottom.backgroundColor = DARK_MODE() ? UIColor(hex: 0x1E242F) : UIColor(hex: 0xE9EAEB)
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        
        self.storyTimeLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        self.articleSourceTime.textColor = self.storyTimeLabel.textColor
        
        self.backgroundColor = .systemPink
    }
    
}

extension ArticleBigImageView: StanceIconViewDelegate {
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
