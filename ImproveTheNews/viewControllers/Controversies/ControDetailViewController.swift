//
//  ControDetailViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/04/2024.
//

import UIKit

class ControDetailViewController: BaseViewController {

    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!

    var slug: String = ""
    let M: CGFloat = CSS.shared.iPhoneSide_padding
    var iPad_W: CGFloat = -1
    
    var twitterText: String = ""
    var twitterUrl: String = ""

    var claims = [Claim]()
    var claimsContainerViewHeightConstraint: NSLayoutConstraint?
    var claimShowMoreViewHeightConstraint: NSLayoutConstraint?
    var claimsPage = 1

    var goDeepers = [StorySearchResult]()
    var goDeeperContainerViewHeightConstraint: NSLayoutConstraint?

    var mainImageView: UIImageView!
    var mainImageViewHeightConstraint: NSLayoutConstraint?
    var creditUrl: String = ""



    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Controversy")
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
        //self.vStack.backgroundColor = .orange
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            //,self.vStack.heightAnchor.constraint(equalToConstant: 1000)
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
        self.vStack.backgroundColor = self.view.backgroundColor
    }


}

// MARK: misc
extension ControDetailViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

extension ControDetailViewController {

    func loadData() {

        self.showLoading()
        ControversiesData.shared.loadControversyData(slug: self.slug, page: self.claimsPage) { (error, controversy) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading Controversy,\nplease try again later.", onCompletion: {
                    self.hideLoading()
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    if let _C = controversy {
                        self.fillContent(_C)
                    }
                }
            }
            
        }
        
    }

}

extension ControDetailViewController {
    
    func fillContent(_ controversy: Controversy) {
        
//        let text = "Where do you stand on this: " + controversy.info.title
//        self.twitterText = text + " www.improvethenews.org/controversy/" + controversy.info.slug
//        self.twitterText = self.twitterText.urlEncodedString()
        
        self.twitterText = "Where do you stand on this: " + controversy.info.title
        self.twitterUrl = ITN_URL() + "/controversy/" + controversy.info.slug
        
        self.addTabs(claimsCount: controversy.claimsTotal,
            goDeeperCount: controversy.goDeeperTotal)
            
        self.addHeaders(controversy.info)
        
        self.addClaims_structure()
        self.claims = []
        self.fillClaims(controversy.claims)
        self.addClaims(self.claims, count: controversy.claimsTotal)
        
        if(controversy.goDeeperTotal > 0) {
            self.addGoDeeper_structure()
            self.goDeepers = []
            self.fillGoDeepers(controversy.goDeepers)
            self.addGoDeepers(self.goDeepers, count: controversy.goDeeperTotal)
        }
        
    }
    
    func addGoDeepers(_ goDeepers: [StorySearchResult], count: Int) {
        let containerView = self.view.viewWithTag(666)!
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width-32
        if(IPAD()){ item_W = (W()-M)/2 }
        
        var val_y: CGFloat = 0
        for (i, GD) in goDeepers.enumerated() {
            let stView = iPhoneStory_vImg_v3(width: item_W)
            //let stView = iPhoneAllNews_vImgCol_v3(width: item_W)
            
            stView.tag = 200 + i
            var val_x: CGFloat = col * item_W
//            if(IPAD() && col==1) {
//                //val_x += M
//            } else {
//                val_x = 16
//            }
  
            if(IPHONE()) {
                val_x = 16
            } else {
                if(col == 1) {
                    val_x += 16
                }
            }
            //print(col, val_x)
            
            containerView.addSubview(stView)
            stView.activateConstraints([
                stView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y),
                stView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                stView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            let ART = MainFeedArticle(story: GD)
            stView.populate(ART)
            stView.showFigureImage(GD.figureImageUrl)
            
//            stView.populate(story: GD)
            if(GD.type == 2) {
                stView.pill.setAsContext()
            }
            
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
                              
                if(col==1 && i==goDeepers.count-1) {
                    val_y += stView.calculateHeight()
                }
            } else {
                val_y += stView.calculateHeight()
            }
        }
        
        self.goDeeperContainerViewHeightConstraint!.constant = val_y
    }
    @objc func storyOnTap(_ sender: UIButton) {
        let index = sender.tag - 700
        
        let GD = self.goDeepers[index]
        //let ART = MainFeedArticle(story: GD)
        
        let vc = StoryViewController()
        vc.storyID = GD.id
        vc.isContext = true
        //vc.story = ART
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    func addGoDeeper_structure() {
        let mainView = self.createContainerView()
        //mainView.backgroundColor = .orange
        mainView.tag = 160
        
        let line = UIView()
        line.backgroundColor = .green
        mainView.addSubview(line)
        line.activateConstraints([
            line.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            line.topAnchor.constraint(equalTo: mainView.topAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        ADD_HDASHES(to: line)
        
        let label = UILabel()
        label.font = DM_SERIF_DISPLAY(20)
        label.textColor = CSS.shared.displayMode().main_textColor
        label.text = "Go deeper"
        mainView.addSubview(label)
        label.activateConstraints([
            label.widthAnchor.constraint(equalToConstant: self.W()),
            label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            label.topAnchor.constraint(equalTo: mainView.topAnchor, constant: M*2)
        ])
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        containerView.backgroundColor = .clear
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: M),
            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)            
        ])
        containerView.tag = 666
        self.goDeeperContainerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        self.goDeeperContainerViewHeightConstraint!.isActive = true

//        // More
//        let moreView = UIView()
//        mainView.addSubview(moreView)
//        moreView.backgroundColor = CSS.shared.displayMode().main_bgColor
//        moreView.activateConstraints([
//            moreView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
//            moreView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
//            moreView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
//        ])
//        moreView.tag = 556
//        self.claimShowMoreViewHeightConstraint = moreView.heightAnchor.constraint(equalToConstant: 88)
//        self.claimShowMoreViewHeightConstraint?.isActive = true
//        
//        if(IPHONE()) {
//            let line = UIView()
//            line.backgroundColor = .green
//            moreView.addSubview(line)
//            line.activateConstraints([
//                line.leadingAnchor.constraint(equalTo: moreView.leadingAnchor),
//                line.trailingAnchor.constraint(equalTo: moreView.trailingAnchor),
//                line.topAnchor.constraint(equalTo: moreView.topAnchor),
//                line.heightAnchor.constraint(equalToConstant: 1)
//            ])
//            ADD_HDASHES(to: line)
//        }
//        
//        let button = UIButton(type: .custom)
//        moreView.addSubview(button)
//        button.activateConstraints([
//            button.heightAnchor.constraint(equalToConstant: 42),
//            button.widthAnchor.constraint(equalToConstant: 150),
//            button.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
//        ])
//        button.setTitle("Show more", for: .normal)
//        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
//        button.titleLabel?.font = AILERON(15)
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 9
//        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
//        button.addTarget(self, action: #selector(loadMoreClaimsOnTap(_:)), for: .touchUpInside)

        // Finally
        mainView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: M).isActive = true
    }
    
    func addTabs(claimsCount: Int, goDeeperCount: Int) {
        ADD_SPACER(to: self.vStack, height: 24)
        let containerView = self.createContainerView(bgColor: .clear, height: 40)
        
        let mainView = UIView()
        //mainView.backgroundColor = .orange
        containerView.addSubview(mainView)
        mainView.activateConstraints([
            mainView.heightAnchor.constraint(equalToConstant: 40),
            mainView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        if(IPHONE()) {
            mainView.widthAnchor.constraint(equalToConstant: SCREEN_SIZE().width).isActive = true
        } else {
            mainView.widthAnchor.constraint(equalToConstant: self.W()).isActive = true
        }
        
        var W: CGFloat = 0
        if(IPHONE()) {
            W = (SCREEN_SIZE().width - (M*4))/3
        } else {
            W = 125
        }
        
        var val_X: CGFloat = M
        for i in 1...3 {
            let tab = UIView()
            tab.backgroundColor = CSS.shared.displayMode().main_bgColor
            tab.layer.cornerRadius = 20
            tab.layer.borderWidth = 1.0
            tab.layer.borderColor = CSS.shared.displayMode().line_color.cgColor
            
            mainView.addSubview(tab)
            tab.activateConstraints([
                tab.heightAnchor.constraint(equalToConstant: 40),
                tab.widthAnchor.constraint(equalToConstant: W),
                tab.topAnchor.constraint(equalTo: mainView.topAnchor),
                tab.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: val_X)
            ])
            
            let label = UILabel()
            label.text = "oOoOoOoOo"
            label.font = CSS.shared.topicSelector_font
            label.textColor = CSS.shared.displayMode().sec_textColor
            tab.addSubview(label)
            label.activateConstraints([
                label.centerXAnchor.constraint(equalTo: tab.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: tab.centerYAnchor)
            ])
            
            switch(i) {
                case 1:
                    label.text = "Claims"
                case 2:
                    label.text = "Go Deeper"
                case 3:
                    label.text = "item 3"
                
                default:
                    NOTHING()
            }
            
            let button = UIButton(type: .system)
            tab.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: tab.leadingAnchor, constant: -5),
                button.trailingAnchor.constraint(equalTo: tab.trailingAnchor, constant: 5),
                button.topAnchor.constraint(equalTo: tab.topAnchor, constant: -5),
                button.bottomAnchor.constraint(equalTo: tab.bottomAnchor, constant: 5)
            ])
            button.tag = 300 + i
            button.addTarget(self, action: #selector(onTabButtonTap(_:)), for: .touchUpInside)
            
            //------------------
            if(i==2 && goDeeperCount==0) {
                tab.hide()
            }
            if(i==3) {
                tab.hide()
            }
            
            //------------------
            val_X += W + M
        }
    }
    
    @objc func onTabButtonTap(_ sender: UIButton) {
        let tag = sender.tag - 300
        var val_Y: CGFloat = 0
        
        switch(tag) {
            case 1:
                let targetView = self.contentView.viewWithTag(140)!
                val_Y = self.contentView.convert(targetView.frame.origin, to: self.scrollView).y
                val_Y += M
                
            case 2:
                let targetView = self.contentView.viewWithTag(160)!
                val_Y = self.contentView.convert(targetView.frame.origin, to: self.scrollView).y
                val_Y += M
                
                let limit = self.scrollView.contentSize.height-self.scrollView.bounds.height
                if(val_Y > limit) {
                    val_Y = limit
                }

//            case 3:
//                view = self.view.viewWithTag(170)!
//                val_Y = self.contentView.convert(view.frame.origin, to: self.scrollView).y
        
            default:
                NOTHING()
        }
        
        //val_Y = 200
        self.scrollView.setContentOffset(CGPoint(x: 0, y: val_Y), animated: true)
    }
    
    func fillClaims(_ claims: [Claim]) {
        for C in claims {
            self.claims.append(C)
        }
    }
    
    func fillGoDeepers(_ goDeppers: [StorySearchResult]) {
        for GD in goDeppers {
            self.goDeepers.append(GD)
        }
    }
    
    func addClaims(_ claims: [Claim], count: Int) {
        let containerView = self.view.viewWithTag(555)!
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        for (i, CL) in claims.enumerated() {
            
            var showChart = false
            if let _firstSource = CL.sources.first, _firstSource.name.lowercased() == "metaculus" {
                showChart = true
            }
        
            var claimView: UIView!
            if(!showChart) {
                claimView = ClaimCellView(width: item_W, showControversyLink: false)
                (claimView as! ClaimCellView).delegate = self
            } else {
                claimView = MetaculusClaimCellView(width: item_W)
                (claimView as! MetaculusClaimCellView).delegate = self
            }

            // ---
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: UIView? = nil
            if(i>0) {
                if(IPHONE()) {
                    prev = containerView.subviews.last
                } else { // IPAD
                    if(i==1) {
                        prev = containerView.subviews.first
                    } else {
                        prev = containerView.subviews[i-2]
                    }
                }
            }
            
            containerView.addSubview(claimView)
            claimView.activateConstraints([
                claimView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                claimView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(i==0) {
                claimView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y).isActive = true
            } else {
            
                if(IPHONE()) {
                    claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                } else { // IPAD
                    if(i==1) { // col2
                        let first = containerView.subviews.first!
                        claimView.topAnchor.constraint(equalTo: first.topAnchor, constant: 0).isActive = true
                    } else {
                        claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                    }
                }
            }
            
            var _H: CGFloat = 0
            if(!showChart) {
                (claimView as! ClaimCellView).populate(with: CL)
                _H = (claimView as! ClaimCellView).calculateHeight()
            } else {
                (claimView as! MetaculusClaimCellView).populate(with: CL)
                _H = (claimView as! MetaculusClaimCellView).calculateHeight()
            }
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += _H
                }
            } else {
                val_y += _H
            }
        }
        
        // Show more --------------
        if(self.claims.count < count) {
            self.showMoreClaimsButton(true)
        } else {
            self.showMoreClaimsButton(false)
        }
        
        // Finally
        self.claimsContainerViewHeightConstraint?.constant = self.calculateContainerViewHeight()
    }
    
    func showMoreClaimsButton(_ visible: Bool) {
        let moreView = self.view.viewWithTag(556)!
        
        if(visible) {
            self.claimShowMoreViewHeightConstraint?.constant = 88
            moreView.show()
        } else {
            self.claimShowMoreViewHeightConstraint?.constant = 0
            moreView.hide()
        }
    }
    
    func addClaims_structure() {
        let mainView = self.createContainerView()
        mainView.tag = 140
        //mainView.backgroundColor = .red
        
        let label = UILabel()
        label.font = DM_SERIF_DISPLAY_resize(20)
        label.textColor = CSS.shared.displayMode().main_textColor
        label.text = "Claims"
        //label.backgroundColor = .red.withAlphaComponent(0.5)
        mainView.addSubview(label)
        label.activateConstraints([
            label.widthAnchor.constraint(equalToConstant: self.W()),
            label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            label.topAnchor.constraint(equalTo: mainView.topAnchor, constant: M*2)
        ])
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        //containerView.backgroundColor = .orange
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: M),
            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)            
        ])
        containerView.tag = 555
        self.claimsContainerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        self.claimsContainerViewHeightConstraint!.isActive = true

        // More
        let moreView = UIView()
        mainView.addSubview(moreView)
        moreView.backgroundColor = CSS.shared.displayMode().main_bgColor
        moreView.activateConstraints([
            moreView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            moreView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            moreView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        moreView.tag = 556
        self.claimShowMoreViewHeightConstraint = moreView.heightAnchor.constraint(equalToConstant: 88)
        self.claimShowMoreViewHeightConstraint?.isActive = true
        
        if(IPHONE()) {
            let line = UIView()
            line.backgroundColor = .green
            moreView.addSubview(line)
            line.activateConstraints([
                line.leadingAnchor.constraint(equalTo: moreView.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: moreView.trailingAnchor),
                line.topAnchor.constraint(equalTo: moreView.topAnchor),
                line.heightAnchor.constraint(equalToConstant: 1)
            ])
            ADD_HDASHES(to: line)
        }
        
        let button = UIButton(type: .custom)
        moreView.addSubview(button)
        button.activateConstraints([
            button.heightAnchor.constraint(equalToConstant: 42),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: moreView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: moreView.centerYAnchor)
        ])
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        button.titleLabel?.font = AILERON(15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
        button.addTarget(self, action: #selector(loadMoreClaimsOnTap(_:)), for: .touchUpInside)

        // Finally
        mainView.bottomAnchor.constraint(equalTo: moreView.bottomAnchor, constant: M).isActive = true
    }
    
    func addMoreClaims(_ claims: [Claim], newCount: Int, count: Int) {
        let containerView = self.view.viewWithTag(555)!
    
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        
        for (_, CL) in claims.enumerated() {
            let claimView = ClaimCellView(width: item_W, showControversyLink: false)
            claimView.delegate = self
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ClaimCellView? = nil
            if(IPHONE()) {
                prev = (containerView.subviews.last as! ClaimCellView)
            } else { // IPAD
                let index = containerView.subviews.count-2
                prev = (containerView.subviews[index] as! ClaimCellView)
            }
            
            containerView.addSubview(claimView)
            claimView.activateConstraints([
                claimView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                claimView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(IPHONE()) {
                claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
            } else { // IPAD
                claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
            }
            claimView.populate(with: CL)
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                }
            }
        }
        
        // Show more --------------
        print(newCount, "de", count)
        if(newCount < count) {
            self.showMoreClaimsButton(true)
        } else {
            self.showMoreClaimsButton(false)
        }
        
        // Finally
        self.claimsContainerViewHeightConstraint?.constant = self.calculateContainerViewHeight()
    }
    
    @objc func loadMoreClaimsOnTap(_ sender: UIButton) {
        self.claimsPage += 1
                
        self.showLoading()
        ControversiesData.shared.loadControversyData(slug: self.slug, page: self.claimsPage) { (error, controversy) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading controversy claims,\nplease try again later.", onCompletion: {
                    //CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    if let _controversy = controversy {
                        self.fillClaims(_controversy.claims)
                        self.addMoreClaims(_controversy.claims, newCount: self.claims.count, count: _controversy.claimsTotal)
                    }
                }
            }
            
        }
    }
    
    func addHeaders(_ listItem: ControversyListItem) {
        let T = listItem.title
        let F = listItem.figures
        
        if(IPHONE()) {
            ADD_SPACER(to: self.vStack, height: 24)
        
            let container1View = self.createContainerView()
            self.addTextHeader(containerView: container1View, width: self.W(), title: T,
                status: listItem.resolved, figures: F,
                image: (listItem.image_url, listItem.image_title, listItem.image_credit),
                type: listItem.controversyType, resolved: (listItem.resolvedText, listItem.resolvedDate))

            var showTwitterButton = false
            
            if(listItem.figures.count > 0) {
                let container2View = self.createContainerView()
                self.addGraph(containerView: container2View, width: SCREEN_SIZE().width, listItem: listItem)
                
                showTwitterButton = true
            } else if(!listItem.image_url.isEmpty) {
                ADD_SPACER(to: self.vStack, height: 8*3)
                showTwitterButton = true
            }

            if(showTwitterButton) {
                let container3View = self.createContainerView(bgColor: .clear, height: 40)
                let button = self.twitterButton()
                container3View.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: container3View.leadingAnchor, constant: M),
                    button.topAnchor.constraint(equalTo: container3View.topAnchor)
                ])
            }
        } else { // IPAD
            let containerView = self.createContainerView()
            let _W = (self.W()-M)/2
            
            let centeredView = UIView()
            //centeredView.backgroundColor = .orange
            containerView.addSubview(centeredView)
            centeredView.activateConstraints([
                centeredView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: M*2),
                centeredView.widthAnchor.constraint(equalToConstant: self.W()),
                centeredView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ])

            let col1View = UIView()
            //col1View.backgroundColor = CSS.shared.displayMode().main_bgColor
            //col1View.backgroundColor = .orange
            centeredView.addSubview(col1View)
            col1View.activateConstraints([
                col1View.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
                col1View.topAnchor.constraint(equalTo: centeredView.topAnchor)
            ])
            if(listItem.figures.count>0) {
                col1View.widthAnchor.constraint(equalToConstant: _W).isActive = true
                
                self.addTextHeader(containerView: col1View, width: _W, title: T,
                    status: listItem.resolved, figures: F,
                    image: (listItem.image_url, listItem.image_title, listItem.image_credit),
                    type: listItem.controversyType,
                    resolved: (listItem.resolvedText, listItem.resolvedDate))
            } else {
                col1View.widthAnchor.constraint(equalToConstant: self.W()).isActive = true
                
                self.addTextHeader(containerView: col1View, width: self.W(), title: T,
                    status: listItem.resolved, figures: F,
                    image: (listItem.image_url, listItem.image_title, listItem.image_credit),
                    type: listItem.controversyType,
                    resolved: (listItem.resolvedText, listItem.resolvedDate))
            }
            
            if(listItem.figures.count>0) {
                let col1b_view = UIView()
                col1b_view.backgroundColor = .clear
                centeredView.addSubview(col1b_view)
                col1b_view.activateConstraints([
                    col1b_view.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
                    col1b_view.topAnchor.constraint(equalTo: col1View.bottomAnchor),
                    col1b_view.widthAnchor.constraint(equalToConstant: _W),
                    col1b_view.heightAnchor.constraint(equalToConstant: 40+M)
                ])
                let button = self.twitterButton()
                col1b_view.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: col1b_view.leadingAnchor, constant: M),
                    button.topAnchor.constraint(equalTo: col1b_view.topAnchor, constant: M)
                ])
                
                let col2View = UIView()
                col2View.backgroundColor = CSS.shared.displayMode().main_bgColor
                centeredView.addSubview(col2View)
                col2View.activateConstraints([
                    col2View.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor),
                    col2View.topAnchor.constraint(equalTo: centeredView.topAnchor),
                    col2View.widthAnchor.constraint(equalToConstant: _W)
                ])
                self.addGraph(containerView: col2View, width: _W, listItem: listItem)
                
                centeredView.bottomAnchor.constraint(equalTo: col1b_view.bottomAnchor, constant: 0).isActive = true
            } else {
                ADD_SPACER(to: self.vStack, height: 16)
            
                let container3View = self.createContainerView(bgColor: .clear, height: 40)
                let button = self.twitterButton()
                container3View.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: container3View.leadingAnchor, constant: M+16),
                    button.topAnchor.constraint(equalTo: container3View.topAnchor)
                ])
            
            
//                let col1b_view = UIView()
//                col1b_view.backgroundColor = .orange
//                centeredView.addSubview(col1b_view)
//                col1b_view.activateConstraints([
//                    col1b_view.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
//                    col1b_view.topAnchor.constraint(equalTo: col1View.bottomAnchor),
//                    col1b_view.widthAnchor.constraint(equalToConstant: _W),
//                    col1b_view.heightAnchor.constraint(equalToConstant: 40+M)
//                ])
//                let button = self.twitterButton()
//                col1b_view.addSubview(button)
//                button.activateConstraints([
//                    button.leadingAnchor.constraint(equalTo: col1b_view.leadingAnchor, constant: M),
//                    button.topAnchor.constraint(equalTo: col1b_view.topAnchor, constant: M)
//                ])
                
                ADD_SPACER(to: self.vStack, height: 8)
            }
            
            if(listItem.figures.count == 0) {
                centeredView.bottomAnchor.constraint(equalTo: col1View.bottomAnchor, constant: 0).isActive = true
            }
            containerView.bottomAnchor.constraint(equalTo: centeredView.bottomAnchor).isActive = true
        }
    }
    
    // ------------------------------------------------------------
    func twitterButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = CSS.shared.cyan
        button.activateConstraints([
            button.widthAnchor.constraint(equalToConstant: 138),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        button.titleLabel?.font = AILERON(16)
        button.setTitleColor(UIColor(hex: 0x19191C), for: .normal)
        button.setTitle("Discuss on       ", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(twitterButtonOnTap(_:)), for: .touchUpInside)
        
        let logoImageView = UIImageView(image: UIImage(named: "twitter_X_logo"))
        button.addSubview(logoImageView)
        logoImageView.activateConstraints([
            logoImageView.widthAnchor.constraint(equalToConstant: 15),
            logoImageView.heightAnchor.constraint(equalToConstant: 15),
            logoImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
        
        return button
    }
    @objc func twitterButtonOnTap(_ sender: UIButton?) {
        //SHARE_ON_TWITTER(text: self.twitterText)
        SHARE_ON_TWITTER_2(url: self.twitterUrl, text: self.twitterText)
    }
    
    // ------------------------------------------------------------
    func addGraph(containerView: UIView, width: CGFloat, listItem: ControversyListItem) {
        let cell = ControversyCellView(width: width, showBottom: false, figuresInteractive: true)
        cell.delegate = self
        cell.populate(with: listItem)
        cell.hideTopLine()
        containerView.addSubview(cell)
        cell.activateConstraints([
            cell.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cell.topAnchor.constraint(equalTo: containerView.topAnchor),
            cell.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cell.heightAnchor.constraint(equalToConstant: cell.calculateHeight())
        ])
        
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: cell.calculateHeight())
        ])
    }
    
    func addTextHeader(containerView: UIView, width: CGFloat, title: String,
        status: String, figures: [FigureForScale],
        image: (String, String, String),
        type: String, resolved: (String, String)) {
        
        self.creditUrl = image.2
        var mustShowImage = false
        if(figures.count == 0) {
            mustShowImage = true
        }
    
        let pill = UILabel()
        pill.text = "CONTROVERSY"
        pill.font = AILERON(12)
        pill.textAlignment = .center
        pill.textColor = UIColor(hex: 0x19191C)
        pill.backgroundColor = UIColor(hex: 0x60C4D6)
        containerView.addSubview(pill)
        pill.activateConstraints([
            pill.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: M),
            pill.topAnchor.constraint(equalTo: containerView.topAnchor),
            pill.widthAnchor.constraint(equalToConstant: 120),
            pill.heightAnchor.constraint(equalToConstant: 24)
        ])
        pill.layer.cornerRadius = 12
        pill.clipsToBounds = true
        
        if(type.uppercased() == "ELECTION_ISSUE") {
            pill.text = "ELECTION ISSUE"
            pill.font = AILERON_SEMIBOLD(12)
            pill.backgroundColor = UIColor(hex: 0xf4e457)
        }
        
        // -------------------------------------------
        let figuresContainer = UIView()
        //figuresContainer.backgroundColor = .orange
        containerView.addSubview(figuresContainer)
        figuresContainer.activateConstraints([
            figuresContainer.leadingAnchor.constraint(equalTo: pill.trailingAnchor, constant: M),
            figuresContainer.topAnchor.constraint(equalTo: pill.topAnchor),
            figuresContainer.heightAnchor.constraint(equalTo: pill.heightAnchor),
            figuresContainer.widthAnchor.constraint(equalToConstant: 150)
        ])
    
        let DIM: CGFloat = 24+4
        var val_x: CGFloat = 0
        var count = 0
    
        for F in figures {
        
            let figureImageView = UIImageView()
            figureImageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
            figuresContainer.addSubview(figureImageView)
            figureImageView.activateConstraints([
                figureImageView.widthAnchor.constraint(equalToConstant: DIM),
                figureImageView.heightAnchor.constraint(equalToConstant: DIM),
                figureImageView.leadingAnchor.constraint(equalTo: figuresContainer.leadingAnchor, constant: val_x),
                figureImageView.topAnchor.constraint(equalTo: figuresContainer.topAnchor, constant: -2)
            ])
            figureImageView.layer.cornerRadius = DIM/2
            figureImageView.clipsToBounds = true
            figureImageView.layer.borderColor = CSS.shared.displayMode().main_bgColor.cgColor
            figureImageView.layer.borderWidth = 2.0
            figureImageView.sd_setImage(with: URL(string: F.image))
            
            val_x += DIM-6
            count += 1
            
            if(count==5) {
                for V in figuresContainer.subviews.reversed() {
                    figuresContainer.bringSubviewToFront(V)
                }
            
                if(figures.count>5) {
                    let moreLabel = UILabel()
                    moreLabel.font = AILERON(11)
                    moreLabel.textColor = CSS.shared.displayMode().main_textColor
                    moreLabel.text = "+\(figures.count-5)"
                    
                    figuresContainer.addSubview(moreLabel)
                    moreLabel.activateConstraints([
                        moreLabel.leadingAnchor.constraint(equalTo: figuresContainer.leadingAnchor, constant: val_x + 15),
                        moreLabel.centerYAnchor.constraint(equalTo: figuresContainer.centerYAnchor)
                    ])
                }
                
                break
            }
        }
        
        // -------------------------------------------
        let statusLabel = UILabel()
        statusLabel.font = DM_SERIF_DISPLAY_resize(18)
        statusLabel.textColor = CSS.shared.displayMode().sec_textColor
        statusLabel.text = "Status:"
        containerView.addSubview(statusLabel)
        statusLabel.activateConstraints([
            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: M),
            statusLabel.topAnchor.constraint(equalTo: pill.bottomAnchor, constant: 24)
        ])
        
        let status2Label = UILabel()
        //status2Label.backgroundColor = .yellow.withAlphaComponent(0.25)
        status2Label.font = statusLabel.font
        status2Label.textColor = CSS.shared.displayMode().main_textColor
        if(status.lowercased() == "resolved"){ status2Label.textColor = CSS.shared.cyan }
        status2Label.text = status
        containerView.addSubview(status2Label)
        status2Label.activateConstraints([
            status2Label.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: M/2),
            status2Label.topAnchor.constraint(equalTo: statusLabel.topAnchor)
        ])
        
        // -------------------------------------------
        let titleLabel = UILabel()
        titleLabel.font = IPHONE() ? DM_SERIF_DISPLAY_resize(22) : DM_SERIF_DISPLAY_resize(32)
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        //titleLabel.backgroundColor = .green
        containerView.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: M),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -M),
            titleLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10)
        ])
        
        // -------------------------------------------
        var showResolved = true
        if(resolved.0.isEmpty || resolved.1.isEmpty) { showResolved = false }
        
        if(showResolved) {
            let resolvedView = VSTACK(into: containerView)

            resolvedView.backgroundColor = .clear
            resolvedView.activateConstraints([
                resolvedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                resolvedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                resolvedView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
                resolvedView.heightAnchor.constraint(equalToConstant: 70)
            ])
            
            let resolutionLabel = UILabel()
            resolutionLabel.textColor = CSS.shared.displayMode().sec_textColor
            resolutionLabel.font = AILERON(15)
            resolutionLabel.text = "Resolution:"
            resolvedView.addSubview(resolutionLabel)
            resolutionLabel.activateConstraints([
                resolutionLabel.leadingAnchor.constraint(equalTo: resolvedView.leadingAnchor),
                resolutionLabel.topAnchor.constraint(equalTo: resolvedView.topAnchor, constant: 12)
            ])
            
            let resolutionDataLabel = UILabel()
            resolutionDataLabel.textColor = CSS.shared.cyan
            resolutionDataLabel.font = AILERON(15)
            resolutionDataLabel.text = resolved.0
            resolvedView.addSubview(resolutionDataLabel)
            resolutionDataLabel.activateConstraints([
                resolutionDataLabel.leadingAnchor.constraint(equalTo: resolutionLabel.trailingAnchor, constant: 8),
                resolutionDataLabel.topAnchor.constraint(equalTo: resolutionLabel.topAnchor)
            ])
            
            let resolvedLabel = UILabel()
            resolvedLabel.textColor = CSS.shared.displayMode().sec_textColor
            resolvedLabel.font = AILERON(15)
            resolvedLabel.text = "Resolved on:"
            resolvedView.addSubview(resolvedLabel)
            resolvedLabel.activateConstraints([
                resolvedLabel.leadingAnchor.constraint(equalTo: resolvedView.leadingAnchor),
                resolvedLabel.topAnchor.constraint(equalTo: resolutionLabel.bottomAnchor, constant: 8),
            ])
            
            let resolvedDataLabel = UILabel()
            resolvedDataLabel.textColor = CSS.shared.cyan
            resolvedDataLabel.font = AILERON(15)
            resolvedDataLabel.text = resolved.1
            resolvedView.addSubview(resolvedDataLabel)
            resolvedDataLabel.activateConstraints([
                resolvedDataLabel.leadingAnchor.constraint(equalTo: resolvedLabel.trailingAnchor, constant: 8),
                resolvedDataLabel.topAnchor.constraint(equalTo: resolvedLabel.topAnchor)
            ])
        }
        
        // -------------------------------------------
        if(mustShowImage && self.mainImageView==nil) {
            self.mainImageView = UIImageView()
            self.mainImageView.backgroundColor = CSS.shared.displayMode().imageView_bgColor
            containerView.addSubview(self.mainImageView)
            self.mainImageView.activateConstraints([
                self.mainImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                self.mainImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                self.mainImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            ])
            
            self.mainImageViewHeightConstraint = self.mainImageView.heightAnchor.constraint(equalToConstant: 215)
            self.mainImageViewHeightConstraint?.isActive = true
            
            if(image.0.lowercased().contains("nato_otan") && image.0.lowercased().contains("logo")) {
                let _image = UIImage(named: "NATO_OTAN.jpg")!
                self.mainImageView.image = _image
                self.resizeMainImageViewHeight(image: _image, width: width)
            } else {
                //Example: let _image = "https://ams3.digitaloceanspaces.com/graffica/2023/02/cocacola-logo.jpeg"
                self.mainImageView.sd_setImage(with: URL(string: image.0)) { (img, error, cacheType, url) in
                    if let _img = img {
                        self.resizeMainImageViewHeight(image: _img, width: width)
                    }
                }
            }
            
            if(IPHONE()) {
                let photolabel = UILabel()
                photolabel.text = "Photo:"
                photolabel.font = ROBOTO(14)
                photolabel.textColor = CSS.shared.displayMode().sec_textColor
                containerView.addSubview(photolabel)
                photolabel.activateConstraints([
                    photolabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 5),
                    photolabel.leadingAnchor.constraint(equalTo: self.mainImageView.leadingAnchor, constant: 16)
                ])
            
                let imageCreditLabel = UILabel()
                imageCreditLabel.text = image.1
                imageCreditLabel.font = ROBOTO(14)
                //imageCreditLabel.lineBreakMode = .byTruncatingTail
                imageCreditLabel.textAlignment = .left
                imageCreditLabel.textColor = CSS.shared.orange
                //imageCreditLabel.backgroundColor = .yellow.withAlphaComponent(0.5)
                containerView.addSubview(imageCreditLabel)
                imageCreditLabel.activateConstraints([
                    imageCreditLabel.topAnchor.constraint(equalTo: photolabel.topAnchor, constant: 0),
                    imageCreditLabel.leadingAnchor.constraint(equalTo: photolabel.trailingAnchor, constant: 5),
                    //imageCreditLabel.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor, constant: -16)
                ])
                
                
                let creditButton = UIButton(type: .custom)
                creditButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
                containerView.addSubview(creditButton)
                creditButton.activateConstraints([
                    creditButton.leadingAnchor.constraint(equalTo: photolabel.leadingAnchor, constant: 0),
                    creditButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -16),
                    creditButton.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
                    creditButton.heightAnchor.constraint(equalToConstant: 25)
                    //creditButton.bottomAnchor.constraint(equalTo: imageCreditLabel.bottomAnchor)
                ])
                creditButton.addTarget(self, action: #selector(creditButtonOnTap(_:)), for: .touchUpInside)
                
            } else {
                let imageCreditLabel = UILabel()
                imageCreditLabel.text = image.1
                imageCreditLabel.font = ROBOTO(14)
                imageCreditLabel.textColor = CSS.shared.orange
                containerView.addSubview(imageCreditLabel)
                imageCreditLabel.activateConstraints([
                    imageCreditLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 5)
                ])
                
                if(IPHONE()) {
                    imageCreditLabel.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor,
                        constant: -5).isActive = true
                } else {
                    imageCreditLabel.trailingAnchor.constraint(equalTo: self.mainImageView.trailingAnchor,
                        constant: 0).isActive = true
                }
                
                let photolabel = UILabel()
                photolabel.text = "Photo:"
                photolabel.font = ROBOTO(14)
                photolabel.textColor = CSS.shared.displayMode().sec_textColor
                containerView.addSubview(photolabel)
                photolabel.activateConstraints([
                    photolabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: 5),
                    photolabel.trailingAnchor.constraint(equalTo: imageCreditLabel.leadingAnchor, constant: -5)
                ])
                
                let creditButton = UIButton(type: .custom)
                creditButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
                containerView.addSubview(creditButton)
                creditButton.activateConstraints([
                    creditButton.leadingAnchor.constraint(equalTo: photolabel.leadingAnchor, constant: -5),
                    creditButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
                    creditButton.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
                    creditButton.heightAnchor.constraint(equalToConstant: 25)
                ])
                creditButton.addTarget(self, action: #selector(creditButtonOnTap(_:)), for: .touchUpInside)
            }
            
        }
        
        // -------------------------------------------
        var _w = width
        if(IPAD()) {
            _w -= (M*2)
        }
        
        var H: CGFloat = 24 + 24 + statusLabel.calculateHeightFor(width: _w) + 10 +
            titleLabel.calculateHeightFor(width: _w)

        if(showResolved) {
            H += 70
        }

        if(mustShowImage) {
            H += 10 + 75 + M
            
            containerView.activateConstraints([
                containerView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: M)
            ])
        } else {
            containerView.activateConstraints([
                containerView.heightAnchor.constraint(equalToConstant: H)
            ])
        }
    }
    
    @objc func creditButtonOnTap(_ sender: UIButton?) {
        if(!self.creditUrl.isEmpty){
            OPEN_URL(self.creditUrl)
        }
    }
    
    func resizeMainImageViewHeight(image: UIImage, width: CGFloat) {
        let H = (image.size.height * width)/image.size.width
        self.mainImageViewHeightConstraint?.constant = H
    }
    
    // ------------------------------------------------------------
    // ------------------------------------------------------------
    // ------------------------------------------------------------
    func createContainerView(bgColor: UIColor = .clear, height: CGFloat? = nil) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = bgColor
        self.vStack.addArrangedSubview(containerView)
        
        if let _H = height {
            containerView.heightAnchor.constraint(equalToConstant: _H).isActive = true
        }
        
        return containerView
    }
    
    func W() -> CGFloat {
        if(IPHONE()) {
            return SCREEN_SIZE().width - (M*2)
        } else {
            if(self.iPad_W == -1) {
                var value: CGFloat = 0
                let w = SCREEN_SIZE().width
                let h = SCREEN_SIZE().height
                
                if(w<h){ value = w }
                else{ value = h }
                self.iPad_W = value - 74
                self.iPad_W -= IPAD_sideOffset()
            }
        
            return self.iPad_W
        }
    }
    
}

extension ControDetailViewController: ClaimCellViewDelegate {
    
    func calculateContainerViewHeight() -> CGFloat {
        let containerView = self.view.viewWithTag(555)!
        var H: CGFloat = 0
        
        if(IPHONE()) {
            for V in containerView.subviews {
                if let _claimView = V as? ClaimCellView {
                    H += _claimView.calculateHeight()
                }
            }
        } else { //IPAD
            var col = 1
            var col1_H: CGFloat = 0
            var col2_H: CGFloat = 0
            
            for V in containerView.subviews {
                if let _claimView = V as? ClaimCellView {
                    if(col==1) {
                        col1_H += _claimView.calculateHeight()
                    } else {
                        col2_H += _claimView.calculateHeight()
                    }
                }
                
                col += 1
                if(col==3){ col=1 }
            }
            
            if(col1_H>col2_H){ H = col1_H }
            else{ H = col2_H }
        }
        
        return H
    }
    
    func claimCellViewOnHeightChanged(sender: ClaimCellView?) {
        let containerView = self.view.viewWithTag(555)!
        for V in containerView.subviews {
            if let _claim = V as? ClaimCellView {
                if(_claim != sender && _claim.isOpen) {
                    _claim.openButtonOnTap(nil, callDelegate: false)
                }
            }
        } 
        
        let H = self.calculateContainerViewHeight()
        self.claimsContainerViewHeightConstraint?.constant = H
    }
    
    func claimCellViewOnFigureTap(sender: ClaimCellView?) {
        if let _slug = sender?.figureSlug {
            let vc = FigureDetailsViewController()
            vc.slug = _slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    func claimCellViewOnControversyTap(sender: ClaimCellView?) {
        if let _slug = sender?.controversySlug {
            if(_slug != self.slug) {
                let vc = ControDetailViewController()
                vc.slug = _slug
                CustomNavController.shared.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension ControDetailViewController: ClaimMetaculusCellViewDelegate {
    func claimMetaculusCellViewOnHeightChanged(sender: MetaculusClaimCellView?) {
    }
    
    func claimMetaculusCellViewOnFigureTap(sender: MetaculusClaimCellView?) {
        if let _slug = sender?.figureSlug {
            let vc = FigureDetailsViewController()
            vc.slug = _slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
    func claimMetaculusCellViewOnControversyTap(sender: MetaculusClaimCellView?) {
    }
}

extension ControDetailViewController: ControversyCellViewDelegate {
    
    func controversyCellViewOnFigureTap(sender: ControversyCellView?) {
        if let _CO = sender {
            let searchFor = _CO.figureSlug
            
            let targetView = self.contentView.viewWithTag(140)!
            let val_Y: CGFloat = self.contentView.convert(targetView.frame.origin, to: self.scrollView).y + (M*2) + 28 + M
            
            var extraY: CGFloat = 0
            let containerView = self.view.viewWithTag(555)!
            
            for view in containerView.subviews { // close them all
                if view is ClaimCellView {
                    let claimView = view as! ClaimCellView
                    if(claimView.isOpen) {
                        claimView.openButtonOnTap(nil, callDelegate: true)
                    }
                }
            }
            
            DELAY(0.2) {
                /**/
                for (i, view) in containerView.subviews.enumerated() {
                    if view is ClaimCellView {
                        let claimView = view as! ClaimCellView
                        
                        if(claimView.figureSlug == searchFor) {
                            claimView.openButtonOnTap(nil, callDelegate: true) // Open target claim
                            extraY = claimView.frame.origin.y
                            break
                        }
                    }
                }
                
                self.scrollView.setContentOffset(CGPoint(x: 0, y: val_Y + extraY), animated: true)
                /**/
            }
            
        }
    }
    
}
