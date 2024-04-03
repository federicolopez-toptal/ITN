//
//  ControversiesViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/04/2024.
//

import UIKit

class ControversiesViewController: BaseViewController {

    let M: CGFloat = CSS.shared.iPhoneSide_padding
    var iPad_W: CGFloat = -1
    
    var page: Int = 0
    
    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!
    
    var items: [ControversyListItem] = []
    var containerViewHeightConstraint: NSLayoutConstraint?
    var showMoreViewHeightConstraint: NSLayoutConstraint?
    
    

    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Latest controversies")
            self.navBar.addBottomLine()

            self.buildContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        //self.scrollView.backgroundColor = .systemPink
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
        
        var extraOffset: CGFloat = 0
        if(IPAD()) { extraOffset = 30 }
        
        self.vStack = VSTACK(into: self.contentView)
        //self.vStack.backgroundColor = .yellow
        self.vStack.activateConstraints([
            self.vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.vStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: extraOffset),
            self.vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
            
        // --------------------------------------
        // Container / Structure
        let mainView = self.createContainerView()
        
        let containerView = UIView()
        mainView.addSubview(containerView)
        //containerView.backgroundColor = .orange
        mainView.addSubview(containerView)
        containerView.activateConstraints([
            containerView.topAnchor.constraint(equalTo: mainView.topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: IPHONE() ? SCREEN_SIZE().width : W()),
            containerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)            
        ])
        containerView.tag = 555
        self.containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 200)
        self.containerViewHeightConstraint!.isActive = true
        
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
        self.showMoreViewHeightConstraint = moreView.heightAnchor.constraint(equalToConstant: 88)
        self.showMoreViewHeightConstraint?.isActive = true
        
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
        button.addTarget(self, action: #selector(loadMoreOnTap(_:)), for: .touchUpInside)
        
        self.showMoreButton(false)
        mainView.bottomAnchor.constraint(equalTo: moreView.bottomAnchor, constant: M).isActive = true
        
        // --------------------------------------
        self.refreshDisplayMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            self.page = 1
            self.items = []
            self.loadContent(page: self.page)
        }
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.scrollView.backgroundColor = self.view.backgroundColor
        self.contentView.backgroundColor = self.view.backgroundColor
        self.vStack.backgroundColor = self.view.backgroundColor
    }
    
    @objc func loadMoreOnTap(_ sender: UIButton) {
        self.page += 1
        self.loadContent(page: self.page)
    }
    
}

// MARK: misc
extension ControversiesViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK: Data
extension ControversiesViewController {
    
    private func loadContent(page P: Int) {
        
        self.showLoading()
        ControversiesData.shared.loadList(page: P) { (error, keyword, total, list) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading the Latest controversies,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                MAIN_THREAD {
                    self.hideLoading()
                    if let _ = keyword, let _T = total, let _L = list {
                        self.fillContent(items: _L, total: _T)
                    }
                }
            }
        }
                
    }
    
    func fillContent(items: [ControversyListItem], total: Int) {
        let containerView = self.view.viewWithTag(555)!
        
        for CO in items {
            self.items.append(CO)
        }
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        if(containerView.subviews.count > 0) {
            for V in containerView.subviews {
                if let _subView = V as? ControversyCellView {
                    val_y += _subView.calculateHeight()
                }
            }
        }
        
        for (i, CO) in items.enumerated() {
            let controView = ControversyCellView(width: item_W)
            if(containerView.subviews.count==0 && i==0){ controView.hideTopLine() }
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ControversyCellView? = nil
            if(i>0) {
                if(IPHONE()) {
                    prev = (containerView.subviews.last as! ControversyCellView)
                } else { // IPAD
                    if(i==1) {
                        prev = (containerView.subviews.first as! ControversyCellView)
                    } else {
                        prev = (containerView.subviews[i-2] as! ControversyCellView)
                    }
                }
            }
            
            containerView.addSubview(controView)
            controView.activateConstraints([
                controView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                controView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(i==0) {
                controView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y).isActive = true
            } else {
            
                if(IPHONE()) {
                    controView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                } else { // IPAD
                    if(i==1) { // col2
                        let first = containerView.subviews.first as! ControversyCellView
                        controView.topAnchor.constraint(equalTo: first.topAnchor, constant: 0).isActive = true
                    } else {
                        controView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                    }
                }
            }
            controView.populate(with: CO)
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += controView.calculateHeight()
                }
            } else {
                val_y += controView.calculateHeight()
            }
            
            if(i==self.items.count-1 && IPAD()) {
                val_y += controView.calculateHeight()
            }
            
        }
        
        // Show more --------------
        if(self.items.count < total) {
            self.showMoreButton(true)
        } else {
            self.showMoreButton(false)
        }

        // Finally
        self.containerViewHeightConstraint?.constant = val_y
    }
    
    
}


// MARK: - Extras
extension ControversiesViewController {

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
    
    func showMoreButton(_ visible: Bool) {
        let moreView = self.view.viewWithTag(556)!
        
        if(visible) {
            self.showMoreViewHeightConstraint?.constant = 88
            moreView.show()
        } else {
            self.showMoreViewHeightConstraint?.constant = 0
            moreView.hide()
        }
    }
    
}
