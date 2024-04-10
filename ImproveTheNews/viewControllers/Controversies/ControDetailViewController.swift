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

    var claims = [Claim]()
    var claimsContainerViewHeightConstraint: NSLayoutConstraint?
    var claimShowMoreViewHeightConstraint: NSLayoutConstraint?
    var claimsPage = 1



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
        ControversiesData.shared.loadControversyData(slug: self.slug, page: self.claimsPage) { (error, listItem, claims, claimsTotal) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading Controversy,\nplease try again later.", onCompletion: {
                    self.hideLoading()
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    
                    if let _listItem = listItem, let _claims = claims, let _claimsTotal = claimsTotal {
                        self.fillContent(_listItem,
                            claims: _claims, claimsTotal: _claimsTotal)
                    }
                }
            }
        }
        
    }

}

extension ControDetailViewController {
    
    func fillContent(_ listItem: ControversyListItem, claims: [Claim], claimsTotal: Int) {
        self.twitterText = "Where do you stand on this: " + listItem.title + " www.improvethenews.org/controversy/" + listItem.slug
        self.addHeaders(listItem)
        
        self.addClaims_structure()
        self.claims = []
        self.fillClaims(claims)
        self.addClaims(self.claims, count: claimsTotal)
    }
    
    func fillClaims(_ claims: [Claim]) {
        for C in claims {
            self.claims.append(C)
        }
    }
    
    func addClaims(_ claims: [Claim], count: Int) {
        let containerView = self.view.viewWithTag(555)!
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        for (i, CL) in claims.enumerated() {
            let claimView = ClaimCellView(width: item_W)
            claimView.delegate = self
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ClaimCellView? = nil
            if(i>0) {
                if(IPHONE()) {
                    prev = (containerView.subviews.last as! ClaimCellView)
                } else { // IPAD
                    if(i==1) {
                        prev = (containerView.subviews.first as! ClaimCellView)
                    } else {
                        prev = (containerView.subviews[i-2] as! ClaimCellView)
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
                        let first = containerView.subviews.first as! ClaimCellView
                        claimView.topAnchor.constraint(equalTo: first.topAnchor, constant: 0).isActive = true
                    } else {
                        claimView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                    }
                }
            }
            claimView.populate(with: CL)
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += claimView.calculateHeight()
                }
            } else {
                val_y += claimView.calculateHeight()
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
        //mainView.backgroundColor = .red
        
        let label = UILabel()
        label.font = DM_SERIF_DISPLAY(20)
        label.textColor = CSS.shared.displayMode().main_textColor
        label.text = "Claims"
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
        
        for (i, CL) in claims.enumerated() {
            let claimView = ClaimCellView(width: item_W)
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
        
//        DELAY(0.25) {
//            self.claimCellViewOnHeightChanged(sender: nil)
//        }
    }
    
    @objc func loadMoreClaimsOnTap(_ sender: UIButton) {
        self.claimsPage += 1
                
        self.showLoading()
        ControversiesData.shared.loadControversyData(slug: self.slug, page: self.claimsPage) { (error, listItem, claims, claimsTotal) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading controversy claims,\nplease try again later.", onCompletion: {
                    //CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()

                    if let _ = listItem, let _claims = claims, let _claimsTotal = claimsTotal {
                        self.fillClaims(_claims)
                        self.addMoreClaims(_claims, newCount: self.claims.count, count: _claimsTotal)
                    }

//                    if let _figure = figure {
//                        self.addMoreClaims(_figure.claims,
//                            newCount: self.claims.count + _figure.claims.count,
//                            count: _figure.claimsCount)
//                            
//                        self.fillClaims(_figure.claims)
//                    }
                    
                }
            }
        }
    }
    
    func addHeaders(_ listItem: ControversyListItem) {
        let T = listItem.title
        let F = listItem.figures
        
        if(IPHONE()) {
            ADD_SPACER(to: self.vStack, height: M*2)
        
            let container1View = self.createContainerView()
            self.addTextHeader(containerView: container1View, width: self.W(), title: T, figures: F)
            
            let container2View = self.createContainerView()
            self.addGraph(containerView: container2View, width: SCREEN_SIZE().width, listItem: listItem)
            
            let container3View = self.createContainerView(bgColor: .clear, height: 40)
            let button = self.twitterButton()
            container3View.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: container3View.leadingAnchor, constant: M),
                button.topAnchor.constraint(equalTo: container3View.topAnchor)
            ])
            
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
            col1View.backgroundColor = CSS.shared.displayMode().main_bgColor
            centeredView.addSubview(col1View)
            col1View.activateConstraints([
                col1View.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor),
                col1View.topAnchor.constraint(equalTo: centeredView.topAnchor),
                col1View.widthAnchor.constraint(equalToConstant: _W)
            ])
            self.addTextHeader(containerView: col1View, width: _W, title: T, figures: F)
            
            let col1b_view = UIView()
            //col1b_view.backgroundColor = .green
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
                button.topAnchor.constraint(equalTo: col1b_view.topAnchor)
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
        SHARE_ON_TWITTER(text: self.twitterText)
    }
    
    // ------------------------------------------------------------
    func addGraph(containerView: UIView, width: CGFloat, listItem: ControversyListItem) {
        let cell = ControversyCellView(width: width, showBottom: false)
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
    
    func addTextHeader(containerView: UIView, width: CGFloat, title: String, figures: [FigureForScale]) {
        let pill = UILabel()
        pill.text = "CONTROVERSY"
        pill.font = AILERON(12)
        pill.textAlignment = .center
        pill.textColor = CSS.shared.displayMode().main_bgColor
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
        let titleLabel = UILabel()
        titleLabel.font = IPHONE() ? DM_SERIF_DISPLAY(20) : DM_SERIF_DISPLAY(32)
        titleLabel.textColor = CSS.shared.displayMode().main_textColor
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        containerView.addSubview(titleLabel)
        titleLabel.activateConstraints([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: M),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -M),
            titleLabel.topAnchor.constraint(equalTo: pill.bottomAnchor, constant: M)
        ])
        
        // -------------------------------------------
        let H: CGFloat = 24 + M + titleLabel.calculateHeightFor(width: width)
        containerView.activateConstraints([
            containerView.heightAnchor.constraint(equalToConstant: H)
        ])
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
        let H = self.calculateContainerViewHeight()
        self.claimsContainerViewHeightConstraint?.constant = H
    }
    
}
