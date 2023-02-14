//
//  FAQViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/12/2022.
//

import UIKit

class FAQViewController: BaseViewController {

    let navBar = NavBarView()
    let titleLabel = UILabel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    
    var heightConstraints = [NSLayoutConstraint]()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("FAQ's")
            
            self.buildContent()
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    
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
        self.contentView.backgroundColor = .green
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])

        self.titleLabel.font = MERRIWEATHER_BOLD(24)
        self.titleLabel.text = ""
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.activateConstraints([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -13),
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13)
        ])

        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .clear //.systemPink
        self.VStack.spacing = 10
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 13),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -13),
            self.VStack.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 0),
            //self.VStack.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 13),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -26),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
    
        self.refreshDisplayMode()
    }
    
    func addContent() {
        
        REMOVE_ALL_SUBVIEWS(from: self.VStack)
        self.heightConstraints = [NSLayoutConstraint]()
        
        for i in 1...15 {
            self.addSection(title: self.titles(i), content: self.contents(i),
                linkTexts: self.linkedTexts(i), urls: self.urls(i), index: i)
        }
        
    }
    
    func addSection(title tText: String, content: String,
        linkTexts: [String], urls: [String], index: Int) {
        
        let sectionView = UIView()
        sectionView.tag = 0
        sectionView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19202D).withAlphaComponent(0.4) : UIColor(hex: 0xF4F6F8)
        self.VStack.addArrangedSubview(sectionView)
        
        let heightConstraint = sectionView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        self.heightConstraints.append(heightConstraint)
        
        let vLine = UIView()
        vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x4C596C) : UIColor(hex: 0x93A0B4)
        sectionView.addSubview(vLine)
        vLine.activateConstraints([
            vLine.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            vLine.topAnchor.constraint(equalTo: sectionView.topAnchor),
            vLine.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
            vLine.widthAnchor.constraint(equalToConstant: 2)
        ])
        
        let titleHStack = HSTACK(into: sectionView)
        titleHStack.backgroundColor = .clear //.orange
        titleHStack.activateConstraints([
            titleHStack.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            titleHStack.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            titleHStack.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 24)
        ])
        
        let titleLabel = UILabel()
        titleLabel.font = MERRIWEATHER_BOLD(20)
        titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
        titleLabel.numberOfLines = 0
        titleLabel.text = tText
        titleLabel.backgroundColor = .clear //.yellow
        titleHStack.addArrangedSubview(titleLabel)
        
        ADD_SPACER(to: titleHStack, backgroundColor: .clear, width: 50)
        
        let icon = UIImageView()
        icon.backgroundColor = .clear //.green
        titleHStack.addSubview(icon)
        icon.activateConstraints([
            icon.widthAnchor.constraint(equalToConstant: 34),
            icon.heightAnchor.constraint(equalToConstant: 34),
            icon.trailingAnchor.constraint(equalTo: titleHStack.trailingAnchor),
            icon.topAnchor.constraint(equalTo: titleHStack.topAnchor, constant: -4)
        ])
                
        let buttonArea = UIButton(type: .custom)
        buttonArea.backgroundColor = .clear //.red.withAlphaComponent(0.5)
        sectionView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -5),
            buttonArea.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 50),
            buttonArea.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            buttonArea.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
        buttonArea.tag = self.VStack.arrangedSubviews.count
        buttonArea.addTarget(self, action: #selector(self.onSectionTap(_:)), for: .touchUpInside)
        
        let contentLabel = HyperlinkLabel.parrafo2(text: content, linkTexts: linkTexts,
            urls: urls, onTap: self.onLinkTap(_:))
        sectionView.addSubview(contentLabel)
        contentLabel.activateConstraints([
            contentLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        ])
        
        var image: UIImage?
        if(index==5){ image = UIImage(named: "galileo") }
        else if(index==6){ image = UIImage(named: "einstein") }
        
        if let _image = image {
            var W: CGFloat = SCREEN_SIZE().width - 13 - 13 - 15 - 15
            if(IPAD()) {
                if(SCREEN_SIZE().height < W){
                    W = SCREEN_SIZE().height - 13 - 13 - 15 - 15
                }
            }
            
            var H: CGFloat = 0
            if(index == 5) {
                H = (W * 175)/468
            } else if(index == 6) {
                H = (W * 216)/1280
            }
            
            let imgView = UIImageView(image: _image)
            sectionView.addSubview(imgView)
            imgView.activateConstraints([
                imgView.widthAnchor.constraint(equalToConstant: W),
                imgView.heightAnchor.constraint(equalToConstant: H),
                imgView.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                imgView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15)
            ])
        }
        
        self.updateSectionHeight(index: self.VStack.arrangedSubviews.count, open: false)
    }
    func updateSectionHeight(index: Int, open: Bool, animate: Bool = false) {
        var W: CGFloat = SCREEN_SIZE().width - 13 - 13 - 15 - 15 - 50
        if(IPAD()) {
            if(SCREEN_SIZE().height < W){
                W = SCREEN_SIZE().height - 13 - 13 - 15 - 15
            }
        }
        
        let sectionView = self.VStack.arrangedSubviews[index-1]
        let vLine = sectionView.subviews[0]
        let hStack = sectionView.subviews[1] as! UIStackView
            let titleLabel = hStack.arrangedSubviews[0] as! UILabel
            let icon = hStack.subviews[2] as! UIImageView
        let contentLabel = sectionView.subviews[3] as! HyperlinkLabel
        
        var imageView: UIImageView?
        if(index==5 || index==6) {
            imageView = sectionView.subviews[4] as? UIImageView
        }
        
        var height: CGFloat = 0
        if(open) {
            sectionView.tag = 1
            height = 24 + titleLabel.calculateHeightFor(width: W) + 24 + contentLabel.calculateHeightFor(width: W+50) + 24
            contentLabel.show()
            vLine.backgroundColor = UIColor(hex: 0xFF643C)
            titleLabel.textColor = UIColor(hex: 0xFF643C)
            
            var imageName = "minusLight"
            if(DARK_MODE()){ imageName = "minusDark" }
            icon.image = UIImage(named: imageName)
            
            imageView?.show()
            var H: CGFloat = 0
            if(index==5 || index==6) {
                if(index == 5) {
                    H = ((W+50) * 175)/468
                } else if(index == 6) {
                    H = ((W+50) * 216)/1280
                }
                height += H + 15
            }
            
        } else {
            sectionView.tag = 0
            height = 24 + titleLabel.calculateHeightFor(width: W) + 24
            contentLabel.hide()
            vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x4C596C) : UIColor(hex: 0x93A0B4)
            titleLabel.textColor = DARK_MODE() ? UIColor(hex: 0x93A0B4) : UIColor(hex: 0x1D242F)
            icon.image = UIImage(named: "plus")
            imageView?.hide()
        }
        
        self.heightConstraints[index-1].constant = height
    }
    
    
    @objc func onSectionTap(_ sender: UIButton?) {
        let tag = sender!.tag
        let sectionView = sender!.superview!
        
        if(sectionView.tag == 0) { // Open section!
            self.updateSectionHeight(index: tag, open: true, animate: true)
            
        } else { // Close section!
            self.updateSectionHeight(index: tag, open: false, animate: true)
        }
    }
    
    

    override func refreshDisplayMode() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        self.navBar.refreshDisplayMode()
        
        self.addContent()
    }

}

// MARK: - Content
extension FAQViewController {

    func titles(_ index: Int) -> String {
        let data = [
            "What's this?",
            "Mission",
            "Why might I like ITN?",
            "Why should I read narratives I disagree with?",
            "Why don't you block all \"disinformation\"?",
            "What's establishment bias?",
            "Who’s behind this?",
            "Is ITN political?",
            "What are ITN’s values?",
            "How does it work?",
            "Is there an app for that?",
            "Won't this contribute to filter bubbles?",
            "How can I help?",
            "What’s your privacy policy?",
            "How can I contact you with feedback?"
        ]
        
        return data[index-1]
    }
    
    func contents(_ index: Int) -> String {
        let data = [
            "This is a free news aggregator and news analysis site developed by a group of researchers at MIT and elsewhere to improve your access to trustworthy news.",
            "Empower people to rise above controversies and understand the world in a nuanced way.",
            """
            1. You’re busy: Most people lack the time to read a range of sources to get an unbiased understanding of what’s really going on. ITN does this for you, conveniently summarizing trustworthy facts – with source links that you can verify yourself.
            
            2. Your voice is heard and respected: Facts aside, you’ll also find fairly presented competing narratives – including your own – regardless of where your home is on the political spectrum.
            
            3. It’s useful to know what other people think: By understanding other people’s arguments, you understand why they do what they do – and have a better chance of persuading them.
            
            4. You won’t get mind-hacked: Many website algorithms push you (for ad revenue) into a filter bubble by reinforcing the narratives you impulse-click on. Just as it's healthier to choose what you eat deliberately rather than impulsively, it's more empowering to choose your news diet deliberately with sliders, as explained in [0].
            
            5. You’re bored: Many news outlets are so partisan that their coverage gets boringly narrow. Quality debates about important controversies can be quite interesting!
            
            6. You don’t want to be part of the problem: If you spend your time consuming biased news that others profit from, you’re feeding the incentive structure that makes people in power manipulate you and others.
            """,
            "It's oft-argued that we should silence those we're convinced are wrong, to avoid giving them a platform. We strongly disagree. Even more important than their freedom to speak, is your freedom to hear. We believe that you're good at calling bs when you see it, and reject the patronizing premise that your mind is too frail to read poor arguments without falling for them. Moreover, to truly understand a political or military battle, we need to understand both sides' arguments. The better we understand poor arguments, the more successfully we can defeat them. Also, when someone blocks information, how can you be sure they’re trying to protect you rather than themselves?",
            "Because figuring out the truth can be hard! If it were simple enough to be delegated to a corporate or governmental fact-checking committee, we would no longer need science, and MIT should fire me (Max). Top physicists spent centuries believing in the wrong theory of gravity, and truth-finding gets no easier when politics and vested interests enter; the Ministry of Truth in Orwell’s novel 1984 reminds us that one of the oldest propaganda tricks is to accuse the other side of spreading disinformation.",
            "When we used Machine Learning to objectively classify a million news articles by their bias [0], the algorithm uncovered two main bias axes: the well-known left-right bias as well as establishment bias. The establishment view is what all big parties and powers agree on, which varies between countries and over time. For example, the old establishment view that women shouldn’t be allowed to vote was successfully challenged. ITN makes it easy for you to compare the perspectives of the pro-establishment mainstream media with those of smaller establishment-critical news outlets that you won’t find in most other news aggregators.",
            "ITN began in 2020 as an MIT research project led by Prof. [0] on machine learning for news classification. Huge thanks to Khaled Shehada, Mindy Long and Arun Wongprommoon for creating the initial news aggregator [1], [2] and [3] and to Tim Woolley for design help. To enable scaling up, ITN was incorporated as a philanthropically funded 501c(3) non-profit organization. Our site and apps will always be free and without ads.",
            "No. Although we respect that people across the political spectrum disagree on how the world ought to be, we believe that news should help everyone agree on how the world is. We therefore work to separate opinion (“ought”) from fact (“is”). We seek to build a team that’s well-balanced across the political spectrum, and encourage it to treat media bias from all sides in the same way.",
            """
            • Trust: We believe that societies work best when their citizens know the truth, and that science is humanity's best truth-finding system. We’ve therefore built ITN around these scientific ideals: questioning authority, upholding free speech, earning trust by making correct predictions, substantiating claims with reliable and verifiable evidence, providing proper context for claims, and subjecting claims to critical peer review.
            
            • Empowerment: We consider it patronizing and anti-democratic for governments and companies to decide for news-readers which facts they should see and which narratives are correct. In contrast, we trust our users to think for themselves, and we therefore empower them with tools for quickly and easily finding whatever facts and narratives they are interested in. This empowerment philosophy extends to the UX/UI of our products, where we let users chose between a wide range of layouts and design options.
            """,
            "The free information sources on our site are powered by machine-learning (ML) and crowdsourcing. We use ML to classify all articles by topics for the news aggregator topics; we’ve shared our code on GitHub; please let us know if you’d like to help us improve it! We also use ML to group together articles about the same story, so that you can compare and contrast their perspectives using our sliders. To produce a story page (example [0]), our editorial team then extracts both the key facts (that all articles agree on) and the key narratives (where the articles differ). We also do academic research on media bias – [1] is a paper on how media bias can be objectively measured from raw data without human input.",
            "Yes: We have free apps for iOS [0] and Android [1].",
            "There's a rich scientific literature on how click-optimizing algorithms at Facebook, Google,etc. have polarized and divided society into groups that each get exposed only to ideas they already agree with. So won't giving people choices such as the left-right slider on this site exacerbate the problem? [0] from David Rand's MIT group suggests the opposite: that people become less susceptible to fake news and bias when given easy access to a range of information, enabling what Kahneman calls \"system 2\" deliberation instead of \"system 1\" impulsive clicking and reacting. Their work also suggests that many people are interested in opinions disagreeing with their own, if expressed in a nuanced and respectful way, but are rarely exposed to this. So let’s not rush to blame consumers rather than providers of news.",
            """
            • If you’d like to support us with a donation, we hope to launch a donation page soon.
            
            • If you’d like to work for us, please email [0]. We’re currently looking for web developers, machine learning researchers and journalists.
            
            • If you have ideas or suggestions for improving our site or apps, please fill out this [1].
            
            Thanks in advance!
            """,
            "Our informal privacy policy is “don’t be creepy”. We’re not trying to profit from you, and we'll never share or sell your data. You’ll find our full privacy policy [0].",
            "This is work in progress, and as you can easily tell, there's lots of room for improvement! Please help us make it better by providing your feedback [0]."
        ]
        
        return data[index-1]
    }
    
    func linkedTexts(_ index: Int) -> [String] {
        if(index == 3) {
            return ["this video"]
        } else if(index == 6) {
            return ["here"]
        } else if(index == 7) {
            return ["Max Tegmark", "website", "iOS app", "Android app"]
        } else if(index == 10) {
            return ["here", "here"]
        } else if(index == 11) {
            return ["here", "here"]
        } else if(index == 12) {
            return ["Recent work"]
        } else if(index == 13) {
            return ["jobs@improvethenews.org", "feedback form"]
        } else if(index == 14) {
            return ["here"]
        } else if(index == 15) {
            return ["here"]
        }
        
        return []
    }
    
    func urls(_ index: Int) -> [String] {
        if(index == 3) {
            return ["https://www.youtube.com/watch?v=PRLF17Pb6vo"]
        } else if(index == 6) {
            return ["https://arxiv.org/abs/2109.00024"]
        } else if(index == 7) {
            return ["https://space.mit.edu/home/tegmark/home.html", "https://www.improvethenews.org/",
                    "https://apps.apple.com/us/app/improve-the-news/id1554856339",
                    "https://play.google.com/store/apps/details?id=com.improvethenews.projecta&pli=1"]
        } else if(index == 10) {
            return ["https://www.improvethenews.org/story/2022/scotus-blocks-revised-state-map-for-wisconsin",
                    "https://arxiv.org/abs/2109.00024"]
        } else if(index == 11) {
            return ["https://apps.apple.com/us/app/improve-the-news/id1554856339",
                    "https://play.google.com/store/apps/details?id=com.improvethenews.projecta&pli=1"]
        } else if(index == 12) {
            return ["https://psyarxiv.com/29b4j"]
        } else if(index == 13) {
            return ["mailto:jobs@improvethenews.org", "local://feedbackForm"]
        } else if(index == 14) {
            return ["local://privacyPolicy"]
        } else if(index == 15) {
            return ["local://feedbackForm"]
        }
        
        return []
    }

}

// MARK: - Event(s)
extension FAQViewController {

    func onLinkTap(_ url: URL) {
        if(url.absoluteString.contains("local://")) {
            if(url.absoluteString.contains("feedbackForm")) {
                let vc = FeedbackFormViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            } else if(url.absoluteString.contains("privacyPolicy")) {
                let vc = PrivacyPolicyViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
        } else {
            OPEN_URL(url.absoluteString)
        }
    }
    
}

extension FAQViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
