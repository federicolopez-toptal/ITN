//
//  FigureDetailsViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 20/03/2024.
//

import UIKit

class FigureDetailsViewController: BaseViewController {

    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!

    let M: CGFloat = CSS.shared.iPhoneSide_padding
    let items_DIM: CGFloat = 92
    let imgs_DIM: CGFloat = 66
    var iPad_W: CGFloat = -1

    var slug: String = ""
    var name: String = ""
    var topics = [SimpleTopic]()
    

    let STORIES_PER_TIME = 2
    var stories = [MainFeedArticle]()
    var storiesBuffer = [MainFeedArticle]()
    var storiesPage = 1
    var storiesContainerViewHeightConstraint: NSLayoutConstraint?
    var storiesCount = 0
    var currentTopic = 0
    
    var claims = [Claim]()
    var claimsContainerViewHeightConstraint: NSLayoutConstraint?
    var claimShowMoreViewHeightConstraint: NSLayoutConstraint?
    var claimsPage = 1

    var shareText = ""
    var shareUrl = ""

    var twitterText = ""
    var facebookText = ""
    var facebookUrl = ""


    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            if(IPHONE()) {
                self.navBar.addComponents([.back, .longTitle, .share, .info])
            } else {
                self.navBar.addComponents([.back, .title, .share, .info])
            }
            self.navBar.addBottomLine()
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: IPHONE_bottomOffset())
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        //self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.vStack = VSTACK(into: self.contentView)
        //self.vStack.backgroundColor = .yellow.withAlphaComponent(0.1)
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
//            ,self.vStack.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        self.refreshDisplayMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            self.loadData()
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        //self.VStack.backgroundColor = self.view.backgroundColor
    }

}

// MARK: misc
extension FigureDetailsViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: Data
extension FigureDetailsViewController {
    
    func loadData() {
        self.claimsPage = 1
        self.storiesPage = 1
    
        self.showLoading()
        PublicFigureData.shared.loadFigure(slug: self.slug) { (error, figure) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading Public Figure,\nplease try again later.", onCompletion: {
                    self.hideLoading()
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    if let _F = figure {
                        self.fillContent(_F)
                    }
                }
            }
        }
    }
    
    func fillContent(_ figure: PublicFigure) {
        //self.name = figure.name
        
        self.navBar.setTitle(figure.name)
        self.addImage(figure.image)
        self.addDescr(figure.description)
//        if(figure.name.lowercased() != "ohchr") {
//            self.addSource(name: figure.sourceText, url: figure.sourceUrl)
//            self.addCredit(name: figure.sourceText, url: figure.sourceUrl)
//        }
        //self.addShare(name: figure.name, slug: figure.slug)
        self.navBar.setShareUrl(ITN_URL() + "/public-figures/" + figure.slug, vc: self)
        
        self.navBar.onInfoButtonTap {
                let popup = StoryInfoPopupView(title: "Source & credit",
                    description: """
                    Public figure about text source: [0]
                    
                    Image credit: [1]
                    """,
                    linkedTexts: [figure.sourceText, figure.imageCredit],
                    links: [figure.sourceUrl, figure.imageUrl],
                    height: 190)
                    
                popup.pushFromBottom()
            }
        
        if(figure.stories.count>0) {
            self.addStoriesTitle(name: figure.name)
            
            //self.addTopics(figure.topics)
            self.addTopics_iPhone(figure.topics)
            
            self.addStories_structure()
                self.stories = []
                self.storiesBuffer = []
                self.fillStories(figure.stories)
                self.storiesCount = figure.storiesCount //
                self.addStories(self.stories, count: figure.storiesCount)
        }
        
        if(figure.claims.count>0) {
            self.addClaims_structure(name: figure.name)
                self.claims = []
                self.fillClaims(figure.claims)
                self.addClaims(self.claims, count: figure.claimsCount)
        }
        
        
//        DELAY(0.5) {
//            self.scrollToBottom()
//        }
    }
    
}

extension FigureDetailsViewController {
    
    // addStories_structure + addStories
    // addClaims_structure + addTopics
    
    func addStoriesTitle(name: String) {
        let containerView = self.createContainerView()
    
        let label = UILabel()
        label.numberOfLines = 0
        label.font = DM_SERIF_DISPLAY_resize(20)
        label.textColor = CSS.shared.displayMode().main_textColor
        label.text = "Stories about \(name)"
        containerView.addSubview(label)
        label.activateConstraints([
            label.widthAnchor.constraint(equalToConstant: self.W()),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        containerView.activateConstraints([
            //containerView.heightAnchor.constraint(equalToConstant: 27.5 + 20)
            containerView.heightAnchor.constraint(equalToConstant: label.calculateHeightFor(width: self.W())+20)
        ])
    }
    
    func addShare(name: String, slug: String) {
        let containerView = self.createContainerView(height: 32 + (M*2))
        
        self.shareText = "Check out the recent claims by \(name) on @verityNews"
        self.shareUrl = "www.improvethenews.org/public-figures/" + slug
        
        let buttonsContainer = UIView()
        //buttonsContainer.backgroundColor = .orange
        containerView.addSubview(buttonsContainer)
        buttonsContainer.activateConstraints([
            buttonsContainer.heightAnchor.constraint(equalToConstant: 32),
            buttonsContainer.widthAnchor.constraint(equalToConstant: 170),
            buttonsContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            buttonsContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: IPAD_sideOffset(multiplier: -0.5))
        ])
        
        let shareLabel = UILabel()
        shareLabel.font = AILERON(16)
        shareLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        shareLabel.text = "Share"
        buttonsContainer.addSubview(shareLabel)
        shareLabel.activateConstraints([
            shareLabel.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor),
            shareLabel.centerYAnchor.constraint(equalTo: buttonsContainer.centerYAnchor)
        ])
        
        let twitterButton = UIButton(type: .system)
        twitterButton.setImage(UIImage(named: "twitter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonsContainer.addSubview(twitterButton)
        twitterButton.activateConstraints([
            twitterButton.leadingAnchor.constraint(equalTo: shareLabel.trailingAnchor, constant: 10),
            twitterButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            twitterButton.widthAnchor.constraint(equalToConstant: 32),
            twitterButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        twitterButton.addTarget(self, action: #selector(twitterButtonOnTap(_:)), for: .touchUpInside)
        self.twitterText = "Check out the recent claims by \(name) on @verityNews www.improvethenews.org/public-figures/" + slug
        
        let facebookButton = UIButton(type: .system)
        facebookButton.setImage(UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonsContainer.addSubview(facebookButton)
        facebookButton.activateConstraints([
            facebookButton.leadingAnchor.constraint(equalTo: twitterButton.trailingAnchor, constant: 10),
            facebookButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            facebookButton.widthAnchor.constraint(equalToConstant: 32),
            facebookButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        facebookButton.addTarget(self, action: #selector(facebookButtonOnTap(_:)), for: .touchUpInside)
        self.facebookText = "Check out the recent claims by \(name) on @verityNews"
        self.facebookUrl = "www.improvethenews.org/public-figures/" + slug
        
        let linkedInButton = UIButton(type: .system)
        linkedInButton.setImage(UIImage(named: "linkedin")?.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonsContainer.addSubview(linkedInButton)
        linkedInButton.activateConstraints([
            linkedInButton.leadingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: 10),
            linkedInButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor),
            linkedInButton.widthAnchor.constraint(equalToConstant: 32),
            linkedInButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        linkedInButton.addTarget(self, action: #selector(linkedInButtonOnTap(_:)), for: .touchUpInside)
    }
    @objc func twitterButtonOnTap(_ sender: UIButton?) {
        SHARE_ON_TWITTER(url: self.shareUrl, text: self.shareText)
    }
    @objc func facebookButtonOnTap(_ sender: UIButton?) {
        SHARE_ON_FACEBOOK(url: self.shareUrl, text: self.shareText)
    }
    @objc func linkedInButtonOnTap(_ sender: UIButton?) {
        SHARE_ON_LINKEDIN(url: self.shareUrl, text: self.shareText)
    }
    
    func addCredit(name creditName: String, url creditUrl: String) {
        let containerView = self.createContainerView()
        
        let label = HyperlinkLabel.parrafo(text: "Image credit: [0]",
            linkTexts: [creditName], urls: [creditUrl], onTap: self.onLinkTap(_:))
//        label.numberOfLines = 0
//        label.textAlignment = .center
        label.font = AILERON(16)
        //label.backgroundColor = .yellow.withAlphaComponent(0.1)
        
        containerView.addSubview(label)
        label.activateConstraints([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: IPAD_sideOffset(multiplier: -0.5)),
            //label.widthAnchor.constraint(equalToConstant: self.W())
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: label.calculateHeightFor(width: self.W()) + M)
        ])
        
        //containerView.backgroundColor = .green.withAlphaComponent(0.25)
    }
    
    func addSource(name sourceName: String, url sourceUrl: String) {
        let containerView = self.createContainerView()
        self.name = sourceName
        
        let label = HyperlinkLabel.parrafo(text: "Source: [0]",
            linkTexts: [sourceName], urls: [sourceUrl], onTap: self.onLinkTap(_:))
        label.font = AILERON(16)
        
        containerView.addSubview(label)
        label.activateConstraints([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: IPAD_sideOffset(multiplier: -0.5))
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: 19.33 + 5)
        ])
    }
    func onLinkTap(_ url: URL) {
        //OPEN_URL(url.absoluteString)
        let vc = ArticleViewController()
        vc.article = MainFeedArticle(url: url.absoluteString)
        vc.altTitle = self.name
        
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func addDescr(_ descr: String) {
        let containerView = self.createContainerView()
        
        let label = UILabel()
        label.font = AILERON_resize(16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = CSS.shared.displayMode().sec_textColor
        label.text = descr
        
        let _W = self.W()
        containerView.addSubview(label)
        label.activateConstraints([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.widthAnchor.constraint(equalToConstant: _W)
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: label.calculateHeightFor(width: _W) + M)
        ])
    }
    
    func addImage(_ image: String) {
        let containerView = self.createContainerView(height: M + self.items_DIM + M)
    
        let borderView = UIView()
        containerView.addSubview(borderView)
        borderView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        borderView.activateConstraints([
            borderView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: IPAD_sideOffset(multiplier: -0.5)),
            borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -M),
            borderView.widthAnchor.constraint(equalToConstant: self.items_DIM),
            borderView.heightAnchor.constraint(equalToConstant: self.items_DIM)
        ])
        borderView.layer.cornerRadius = self.items_DIM/2
        
        let imageView = UIImageView()
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        borderView.addSubview(imageView)
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: self.imgs_DIM),
            imageView.heightAnchor.constraint(equalToConstant: self.imgs_DIM),
            imageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        ])
        imageView.layer.cornerRadius = self.imgs_DIM/2
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: image))
    }
    
}
