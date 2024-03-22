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
    let iPad_W: CGFloat = 950

    var slug: String = ""
    var topics = [SimpleTopic]()
    var stories = [MainFeedArticle]()


    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
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
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    
    private func loadData() {
        self.showLoading()
        PublicFigureData.shared.loadFigure(slug: self.slug) { (error, figure) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading Public Figure,\nplease try again later.", onCompletion: {
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
        self.navBar.setTitle(figure.name)
        self.addImage(figure.image)
        self.addDescr(figure.description)
        self.addSource(name: figure.sourceText, url: figure.sourceUrl)
        self.addCredit(name: figure.sourceText, url: figure.sourceUrl)
        self.addStoriesTitle(name: figure.name)
        self.addTopics(figure.topics)
        self.addStories(figure.stories, count: figure.storiesCount)
        
//        DELAY(0.5) {
//            self.scrollToBottom()
//        }
    }
    
}

extension FigureDetailsViewController {
    
    func addStories(_ stories: [MainFeedArticle], count: Int) {
        self.stories = stories
        let mainView = self.createContainerView()
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        //containerView.backgroundColor = .yellow
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: mainView.topAnchor)
        ])
        containerView.tag = 222
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        for (i, ST) in stories.enumerated() {
            let stView = iPhoneStory_vImg_v3(width: item_W)
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            containerView.addSubview(stView)
            stView.activateConstraints([
                stView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
                stView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                stView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            stView.populate(ST)
            
            let buttonArea = UIButton(type: .custom)
            //buttonArea.backgroundColor = .red.withAlphaComponent(0.5)
            containerView.addSubview(buttonArea)
            buttonArea.activateConstraints([
                buttonArea.leadingAnchor.constraint(equalTo: stView.leadingAnchor),
                buttonArea.trailingAnchor.constraint(equalTo: stView.trailingAnchor),
                buttonArea.topAnchor.constraint(equalTo: stView.topAnchor),
                buttonArea.heightAnchor.constraint(equalToConstant: stView.calculateHeight())
            ])
            buttonArea.addTarget(self, action: #selector(storyOnTap(_:)), for: .touchUpInside)
            buttonArea.tag = 700 + i
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += stView.calculateHeight()
                }
            } else {
                val_y += stView.calculateHeight()
            }
            
        }
        
        containerView.heightAnchor.constraint(equalToConstant: val_y).isActive = true
        mainView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: M).isActive = true
    }
    @objc func storyOnTap(_ sender: UIButton) {
        let index = sender.tag - 700
        
        let vc = StoryViewController()
        vc.story = self.stories[index]
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    // addTopics in "FigureDetails_extras.swift"
    
    func addStoriesTitle(name: String) {
        let containerView = self.createContainerView()
    
        let label = UILabel()
        label.font = DM_SERIF_DISPLAY(20)
        label.textColor = CSS.shared.displayMode().main_textColor
        label.text = "Stories about \(name)"
        containerView.addSubview(label)
        label.activateConstraints([
            label.widthAnchor.constraint(equalToConstant: self.W()),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: 27.5 + 20)
        ])
    }
    
    func addCredit(name creditName: String, url creditUrl: String) {
        let containerView = self.createContainerView()
        
        let label = HyperlinkLabel.parrafo(text: "Image credit: [0]",
            linkTexts: [creditName], urls: [creditUrl], onTap: self.onLinkTap(_:))
        label.font = AILERON(16)
        
        containerView.addSubview(label)
        label.activateConstraints([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: 19.33 + 30)
        ])
    }
    
    func addSource(name sourceName: String, url sourceUrl: String) {
        let containerView = self.createContainerView()
        
        let label = HyperlinkLabel.parrafo(text: "Source: [0]",
            linkTexts: [sourceName], urls: [sourceUrl], onTap: self.onLinkTap(_:))
        label.font = AILERON(16)
        
        containerView.addSubview(label)
        label.activateConstraints([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: 19.33 + 5)
        ])
    }
    func onLinkTap(_ url: URL) {
        OPEN_URL(url.absoluteString)
    }
    
    func addDescr(_ descr: String) {
        let containerView = self.createContainerView()
        
        let label = UILabel()
        label.font = AILERON(16)
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
            borderView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
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
