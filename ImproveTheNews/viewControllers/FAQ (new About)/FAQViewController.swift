//
//  FAQViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 22/12/2022.
//

import UIKit

class FAQViewController: BaseViewController {

    var descrLabel = HyperlinkLabel()
            
    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var VStack: UIStackView!
    var firstItemOpened: Bool = false
    var heightConstraints = [NSLayoutConstraint]()
    
    var initialTextOpened = false
    var stories: FAQ_Stories? = FAQ_Stories()
    
    var normalStories = [StorySearchResult]()
    var contextStories = [StorySearchResult]()
    
    
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
            self.navBar.setTitle("About")
            self.navBar.addBottomLine()
            
            self.buildContent()
            if(self.firstItemOpened) {
                self.updateSectionHeight(index: 1, open: true)
                self.firstItemOpened = false
                
                let FAQ = self.contentView.viewWithTag(951) as! UILabel
                let W = SCREEN_SIZE().width - 18 - 18
                let H = 13 + descrLabel.calculateHeightFor(width: W) + 25 + FAQ.calculateHeightFor(width: W + 15)
                DELAY(0.5) {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: H), animated: true)
                }
            }
        }
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        //DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
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
        self.changeInitialText(setValueTo: false)
        
        var sideMargin: CGFloat = 18
        if(IPAD()){ sideMargin = 60 }
           
        self.contentView.addSubview(self.descrLabel)
        self.descrLabel.activateConstraints([
            self.descrLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sideMargin),
            self.descrLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -sideMargin),
            self.descrLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                constant: IPHONE() ? 16*2 : 60)
        ])
        
        let FAQ = UILabel()
        FAQ.tag = 951
        FAQ.text = "Frequently Asked Questions"
        FAQ.font = DM_SERIF_DISPLAY(23)
        FAQ.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.contentView.addSubview(FAQ)
        FAQ.activateConstraints([
            FAQ.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sideMargin),
            FAQ.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -sideMargin),
            FAQ.topAnchor.constraint(equalTo: self.descrLabel.bottomAnchor,
                constant: IPHONE() ? 25 :  50)
        ])

        self.VStack = VSTACK(into: self.contentView)
        self.VStack.backgroundColor = .clear //.systemPink
        self.VStack.spacing = 0
        self.VStack.activateConstraints([
            self.VStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                constant: IPHONE() ? 0 : 60),
            self.VStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                constant: IPHONE() ? 0 : -60),
            self.VStack.topAnchor.constraint(equalTo: FAQ.bottomAnchor, constant: 30),
            //self.VStack.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 13),
            self.VStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -26),
            //VStack.heightAnchor.constraint(equalToConstant: 1200) //!!!
        ])
    
        self.refreshDisplayMode()
    }
    
    func changeInitialText(setValueTo value: Bool? = nil) {
        if let _newValue = value {
            self.initialTextOpened = _newValue
        } else {
            self.initialTextOpened = !self.initialTextOpened
        }
        
        if(self.initialTextOpened) {
            self.setParrafo2to(label: self.descrLabel, text: self.mainContent_A(),
                linkTexts: ["Max Tegmark", "Show Less"],
                urls: ["https://physics.mit.edu/faculty/max-tegmark/", "local://shortText"],
                onTap: self.onLinkTap(_:))
        } else {
            self.setParrafo2to(label: self.descrLabel, text: self.mainContent_B(),
                linkTexts: ["Show More"],
                urls: ["local://initialText"],
                onTap: self.onLinkTap(_:))
        }
        
        self.descrLabel.setLineSpacing(lineSpacing: 6)
    }
    
    func addContent() {
        
        REMOVE_ALL_SUBVIEWS(from: self.VStack)
        self.heightConstraints = [NSLayoutConstraint]()
        
        for i in 1...(15-1) {
            print("I", i)
            
            self.addSection(title: self.titles(i), content: self.contents(i),
                linkTexts: self.linkedTexts(i), urls: self.urls(i), index: i)
        }
        
        //-----
        self.stories?.loadData(callback: { (stories, error) in
            if let _stories = stories {
                self.normalStories = _stories.filter { $0.type == 1 }
                self.contextStories = _stories.filter { $0.type == 2 }
                                
                MAIN_THREAD {
                    self.addStories(self.normalStories, type: 1, mainText: "Stories",
                        secText: "Yes, we have a full editorial team who create specially curated stories, screened from the most popular articles of the day — check out some of the latest added stories below to get started on Verity!")
                        
//                    self.addStories(self.contextStories, type: 2, mainText: "What if I need more context?",
//                        secText: "Check out some of our evergreen context articles if you want to take a deeper dive into a story")
                        
                    //self.scrollTo(valY: 6000) //!!!
                }
            }
        })
        //-----
    }
    
    func addStories(_ stories: [StorySearchResult], type: Int, mainText: String, secText: String) {
        if(stories.count==0){ return }
        
        let sectionView = UIView()
        sectionView.tag = 600 + type
        //sectionView.backgroundColor = .yellow.withAlphaComponent(0.3)
        ADD_SPACER(to: self.VStack, height: 10)
        self.VStack.addArrangedSubview(sectionView)
        
        let title = UILabel()
        title.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        //title.backgroundColor = .red.withAlphaComponent(0.3)
        title.font = DM_SERIF_DISPLAY(23)
        title.text = mainText
        sectionView.addSubview(title)
        title.activateConstraints([
            title.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15)
        ])
        
        let descr = UILabel()
        descr.font = AILERON(16)
        descr.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x1D242F)
        descr.numberOfLines = 0
        descr.text = secText
        descr.setLineSpacing(lineSpacing: 6)
        //descr.backgroundColor = .green
        sectionView.addSubview(descr)
        descr.activateConstraints([
            descr.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 25),
            descr.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            descr.trailingAnchor.constraint(equalTo: title.trailingAnchor)
        ])
        
        var sideMargin: CGFloat = 15
        if(IPAD()){ sideMargin = 60 }
        let W: CGFloat = SCREEN_SIZE_iPadSideTab().width - (13*2) - (sideMargin*2)
        var posY: CGFloat = 20 + title.calculateHeightFor(width: W) + 20 + descr.calculateHeightFor(width: W) + 20 + 15
        
        var hSep: CGFloat = CSS.shared.iPhoneSide_padding
        if(IPAD()){ hSep = 32 }
        var W2 = (W - hSep)/2
        
        if(IPHONE()) {
            W2 = SCREEN_SIZE().width - (CSS.shared.iPhoneSide_padding * 2)
        
            var storiesCopy = stories
            while(storiesCopy.count>0) {
                //CSS.shared.iPhoneSide_padding
            
                var H1: CGFloat = 1
                var H2: CGFloat = 1
                let VIEW1 = iPhoneAllNews_vImgCol_v3(width: W2)
                let VIEW2 = iPhoneAllNews_vImgCol_v3(width: W2)
                
                // item 1
                if let _A = storiesCopy.first {
                    VIEW1.refreshDisplayMode()
                    VIEW1.populate(story: _A)
                    H1 = VIEW1.calculateHeight()
                    sectionView.addSubview(VIEW1)
                    
                    VIEW1.activateConstraints([
                        VIEW1.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
                        VIEW1.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
                        VIEW1.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: posY),
                        VIEW1.heightAnchor.constraint(equalToConstant: H1)
                    ])
                    
                    posY += H1
                    storiesCopy.removeFirst()
                }
                
                // item 2
                if let _A = storiesCopy.first {
                    VIEW2.refreshDisplayMode()
                    VIEW2.populate(story: _A)
                    H2 = VIEW2.calculateHeight()
                    sectionView.addSubview(VIEW2)
                    
                    VIEW2.activateConstraints([
                        VIEW2.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: CSS.shared.iPhoneSide_padding),
                        VIEW2.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -CSS.shared.iPhoneSide_padding),
                        VIEW2.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: posY),
                        VIEW2.heightAnchor.constraint(equalToConstant: H2)
                    ])
                    
                    posY += H2
                    storiesCopy.removeFirst()
                }
                
                break //new 🤷‍♂️
            }
        } else {
            var storiesCopy = stories
            while(storiesCopy.count>0) {
                let colsHStack = HSTACK(into: sectionView, spacing: hSep)
                
                colsHStack.activateConstraints([
                    colsHStack.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor,
                        constant: CSS.shared.iPhoneSide_padding),
                    colsHStack.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor,
                        constant: -CSS.shared.iPhoneSide_padding),
                    colsHStack.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: posY)
                ])
                
                var H1: CGFloat = 1
                var H2: CGFloat = 1
                let VIEW1 = iPhoneAllNews_vImgCol_v3(width: W2)
                let VIEW2 = iPhoneAllNews_vImgCol_v3(width: W2)
                
                // item 1
                if let _A = storiesCopy.first {
                    VIEW1.refreshDisplayMode()
                    VIEW1.populate(story: _A)
                    H1 = VIEW1.calculateHeight()
                    colsHStack.addArrangedSubview(VIEW1)
                    VIEW1.activateConstraints([
                        VIEW1.widthAnchor.constraint(equalToConstant: W2)
                    ])
                    
                    storiesCopy.removeFirst()
                } else {
                    H1 = 0
                    ADD_SPACER(to: colsHStack, width: W2)
                }
                
                // item 2
                if let _A = storiesCopy.first {
                    VIEW2.refreshDisplayMode()
                    VIEW2.populate(story: _A)
                    H2 = VIEW2.calculateHeight()
                    colsHStack.addArrangedSubview(VIEW2)
                    VIEW2.activateConstraints([
                        VIEW2.widthAnchor.constraint(equalToConstant: W2)
                    ])
                    
                    storiesCopy.removeFirst()
                } else {
                    H2 = 0
                    ADD_SPACER(to: colsHStack, width: W2)
                }
                
                let maxH = (H1 > H2) ? H1 : H2
                VIEW1.heightAnchor.constraint(equalToConstant: maxH).isActive = true
                VIEW2.heightAnchor.constraint(equalToConstant: maxH).isActive = true

                posY += maxH + (IPAD() ? 32 : 0)
                
                break //new 🤷‍♂️
            }
        }
        
        sectionView.activateConstraints([
            sectionView.heightAnchor.constraint(equalToConstant: posY)
        ])
    }
    
    func addSection(title tText: String, content: String,
        linkTexts: [String], urls: [String], index: Int) {
        
        let sectionView = UIView()
        sectionView.tag = 0
        sectionView.backgroundColor = self.view.backgroundColor // DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xF4F6F8)
        self.VStack.addArrangedSubview(sectionView)
        
        let heightConstraint = sectionView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        self.heightConstraints.append(heightConstraint)
        
        let vLine = UIView()
        vLine.backgroundColor = .red //DARK_MODE() ? UIColor(hex: 0x4C596C) : UIColor(hex: 0x93A0B4)
        sectionView.addSubview(vLine)
        vLine.activateConstraints([
            vLine.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            vLine.topAnchor.constraint(equalTo: sectionView.topAnchor),
            vLine.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
            vLine.widthAnchor.constraint(equalToConstant: 2)
        ])
        vLine.alpha = 0
        
        let titleHStack = HSTACK(into: sectionView)
        titleHStack.backgroundColor = .clear //.orange
        titleHStack.activateConstraints([
            titleHStack.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            titleHStack.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            titleHStack.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 24)
        ])
        
        let titleLabel = UILabel()
        titleLabel.font = DM_SERIF_DISPLAY(20)
        titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        titleLabel.numberOfLines = 0
        titleLabel.text = tText
        titleLabel.backgroundColor = .clear //.yellow
        titleHStack.addArrangedSubview(titleLabel)
        //titleLabel.backgroundColor = .yellow.withAlphaComponent(0.25)
        
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
        contentLabel.setLineSpacing(lineSpacing: 6)
        sectionView.addSubview(contentLabel)
        contentLabel.activateConstraints([
            contentLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -15),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        ])
        //contentLabel.backgroundColor = .yellow.withAlphaComponent(0.25)
        
        let imageInfo = self.images(index)
        let image: UIImage? = imageInfo?.0
//        if(index==5){ image = UIImage(named: "galileo") }
//        else if(index==6){ image = UIImage(named: "einstein") }
        
        if let _image = image {
            var W: CGFloat = SCREEN_SIZE().width - 13 - 13 - 15 - 15
            if(IPAD()) {
                W = SCREEN_SIZE().width - 60 - 60 - 15 - 15
                if(SCREEN_SIZE().height < W){
                    W = SCREEN_SIZE().height - 60 - 60 - 15 - 15
                }
            }
            
            let _w = imageInfo!.1.width
            let _h = imageInfo!.1.height
            let H: CGFloat = (W * _h)/_w
//            var H: CGFloat = 0
//            if(index == 5) {
//                H = (W * 175)/468
//            } else if(index == 6) {
//                H = (W * 216)/1280
//            }
            
            let imgView = UIImageView(image: _image)
            sectionView.addSubview(imgView)
            imgView.activateConstraints([
                imgView.widthAnchor.constraint(equalToConstant: W),
                imgView.heightAnchor.constraint(equalToConstant: H),
                imgView.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
                imgView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 15)
            ])
        }
        
        let hTopLine = UIView()
        hTopLine.backgroundColor = self.view.backgroundColor //DARK_MODE() ? UIColor(hex: 0xBBBDC0).withAlphaComponent(0.35) : .black.withAlphaComponent(0.1)
        sectionView.addSubview(hTopLine)
        hTopLine.activateConstraints([
            hTopLine.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
            hTopLine.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
            hTopLine.topAnchor.constraint(equalTo: sectionView.topAnchor),
            hTopLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        ADD_HDASHES(to: hTopLine)
        
        if(index==14) {
            let hBottomLine = UIView()
            hBottomLine.backgroundColor = self.view.backgroundColor
            sectionView.addSubview(hBottomLine)
            hBottomLine.activateConstraints([
                hBottomLine.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor),
                hBottomLine.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor),
                hBottomLine.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
                hBottomLine.heightAnchor.constraint(equalToConstant: 1)
            ])
            ADD_HDASHES(to: hBottomLine)
        }
        
        self.updateSectionHeight(index: self.VStack.arrangedSubviews.count, open: false)
    }
    func updateSectionHeight(index: Int, open: Bool, animate: Bool = false, extraHeight: CGFloat = 0) {
        var W: CGFloat = SCREEN_SIZE().width - 15 - 15
        
        //13 - 13 - 15 - 15 - 50
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
            height = 24 + titleLabel.calculateHeightFor(width: W-50) + 24 + contentLabel.calculateHeightFor(width: W) + 24
            contentLabel.show()
            vLine.backgroundColor = UIColor(hex: 0xFF643C)
            titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            
//            var imageName = "minusLight"
//            if(DARK_MODE()){ imageName = "minusDark" }
            icon.image = UIImage(named: DisplayMode.imageName("about-up"))
            
            imageView?.show()
            var H: CGFloat = 0
            if let _imageInfo = self.images(index) {
                let _w = _imageInfo.1.width
                let _h = _imageInfo.1.height
                H = ((W+50) * _h)/_w
            }
//            if(index==5 || index==6) {
//                if(index == 5) {
//                    H = ((W+50) * 175)/468
//                } else if(index == 6) {
//                    H = ((W+50) * 216)/1280
//                }
                height += H + 15
//            }
            
            
        } else {
            sectionView.tag = 0
            height = 24 + titleLabel.calculateHeightFor(width: W-50) + 24
            contentLabel.hide()
            vLine.backgroundColor = DARK_MODE() ? UIColor(hex: 0x4C596C) : UIColor(hex: 0x1D242F)
            titleLabel.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
            icon.image = UIImage(named: DisplayMode.imageName("about-down"))
            imageView?.hide()
        }
        
        self.heightConstraints[index-1].constant = height + extraHeight
    }
    
    
    @objc func onSectionTap(_ sender: UIButton?) {
        let tag = sender!.tag
        let sectionView = sender!.superview!
        
        print("TAG", tag)
        if(sectionView.tag == 0) { // Open section!
            var extraHeight: CGFloat = 0
            if(IPAD()) {
                extraHeight = 30
                if(tag == 5) {
                    extraHeight += 30
                } else if(tag==7) {
                    extraHeight = 0
                } else if(tag==6) {
                    extraHeight -= 20
                }
            }
            
            self.updateSectionHeight(index: tag, open: true, animate: true, extraHeight: extraHeight)
        } else { // Close section!
            self.updateSectionHeight(index: tag, open: false, animate: true)
        }
    }

    override func refreshDisplayMode() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        //DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        //self.descrLabel!.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        self.navBar.refreshDisplayMode()
        
        self.addContent()
    }

    func setParrafo2to(label: HyperlinkLabel,text: String, linkTexts: [String], urls: [String],
        onTap: @escaping (URL) -> Void) {
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: AILERON(16),
            .foregroundColor: DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        ])

        for (i, url) in urls.enumerated() {
            let attributes: [NSAttributedString.Key: Any] = [
                .hyperlink: URL(string: url)!,
                .font: AILERON(16)
            ]
            let urlAttributedString = NSAttributedString(string: linkTexts[i], attributes: attributes)
            let range = (attributedString.string as NSString).range(of: "[\(i)]")
            attributedString.replaceCharacters(in: range, with: urlAttributedString)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length))
        
        // -------------------------
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.didTapOnURL = onTap
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
            } else if(url.absoluteString.contains("initialText") || url.absoluteString.contains("shortText") ) {
                self.changeInitialText()
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

// MARK: - Stories
extension FAQViewController {

    func scrollTo(valY: CGFloat) {
        let bottomOffset = CGPoint(x: 0, y: valY)
        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }

}

extension FAQViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if let _view1 = self.view.viewWithTag(600+1) {
            _view1.removeFromSuperview()
        }
        if let _view2 = self.view.viewWithTag(600+2) {
            _view2.removeFromSuperview()
        }
        
        self.addStories(self.normalStories, type: 1, mainText: "Stories",
                        secText: "Yes, we have a full editorial team who create specially curated stories, screened from the most popular articles of the day — check out some of the latest added stories below to get started on Verity!")
                        
//        self.addStories(self.contextStories, type: 2, mainText: "What if I need more context?",
//                        secText: "Check out some of our evergreen context articles if you want to take a deeper dive into a story")
    }
}
