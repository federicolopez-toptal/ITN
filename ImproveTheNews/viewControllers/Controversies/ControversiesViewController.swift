//
//  ControversiesViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 01/04/2024.
//

import UIKit

class ControversiesViewController: BaseViewController {

    let M: CGFloat = CSS.shared.iPhoneSide_padding
    let GRAPH_HEIGHT: CGFloat = 250
    var iPad_W: CGFloat = -1
    
    var page: Int = 0
    
    let navBar = NavBarView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var vStack: UIStackView!
    
    var portalInfoView = UIStackView()
    var portalInfoViewHeightConstraint: NSLayoutConstraint? = nil
    
    var items: [ControversyListItem] = []
    var containerViewHeightConstraint: NSLayoutConstraint?
    var showMoreViewHeightConstraint: NSLayoutConstraint?
    
    var currentTopic = -1
    var topics = [SimpleTopic]()
    let topicsContainer = UIView()
    
    var loadsCount = 0
    
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            //self.navBar.addComponents([.back, .title])
            self.navBar.addComponents([.menuIcon, .title, .share, .question])
//            self.navBar.setTitle("Latest controversies")
            self.navBar.setTitle("Controversies")
            self.navBar.addBottomLine()
            
            // ------------------------------
            self.navBar.onQuestionButtonTap {
                let vc = FAQViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
                
                DELAY(0.4) {
                    vc.scrollToControversies()
                }
            }
            
            // -----------------------------
            self.navBar.setShareUrl(ITN_URL() + "/controversies", vc: self)
            
//            self.navBar.onShareButtonTap {
//                let popup = SharePopupView(text: "Share Controversies",
//                    height: 200,
//                    url: ITN_URL() + "/controversies",
//                    shareText: "Controversies")
//                popup.pushFromBottom()
//            }
            

            self.buildContent()
        }
    }
        
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        //self.scrollView.backgroundColor = .systemPink
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
            
        // -------------------------------------- //
        // Container / Structure
        ADD_SPACER(to: self.vStack, height: 16)
        
        self.topicsContainer.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.vStack.addArrangedSubview(self.topicsContainer)
        self.topicsContainer.activateConstraints([
            self.topicsContainer.heightAnchor.constraint(equalToConstant: 40+16)
        ])
        
        self.portalInfoView = VSTACK(into: self.vStack)
        self.portalInfoView.backgroundColor = .clear //.orange
        self.portalInfoViewHeightConstraint = self.portalInfoView.heightAnchor.constraint(equalToConstant: 50)
        self.portalInfoViewHeightConstraint?.isActive = true
        self.portalInfoView.hide()
        
        
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
            line.tag = 444
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
        self.refreshDisplayMode_local()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            self.page = 1
            self.items = []
            
            self.loadsCount = 0
            self.loadContent(page: self.page)
        }
    }
    
    func refreshDisplayMode_local() {
        self.navBar.refreshDisplayMode()
        
        let C = CSS.shared.displayMode().main_bgColor
        
        self.view.backgroundColor = C
        self.scrollView.backgroundColor = C
        self.contentView.backgroundColor = C
        self.vStack.backgroundColor = C
    }
    
    override func refreshDisplayMode() {
        self.refreshDisplayMode_local()
        
        let containerView = self.view.viewWithTag(555)!
        REMOVE_ALL_SUBVIEWS(from: containerView)
        
        let moreView = self.view.viewWithTag(556)!
        moreView.backgroundColor = self.view.backgroundColor
        moreView.hide()
        
        for sView in moreView.subviews {
            if(sView.tag == 444) {
                ADD_HDASHES(to: sView)
            } else {
                if let _button = sView as? UIButton {
                    _button.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
                    _button.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xBBBDC0)
                }
            }
        }
        
        self.refreshDisplayModeForTopics()
        
        self.page = 1
        self.items = []
        self.loadsCount = 0
        self.loadContent(page: self.page)
    }
    
    @objc func loadMoreOnTap(_ sender: UIButton) {
        self.page += 1
        self.loadsCount = 0
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
        self.portalInfoView.hide()
        self.showMoreButton(false)
        
        var T = ""
        if(self.topics.count>0 && self.currentTopic != -1) {
            T = self.topics[self.currentTopic].slug
            if(T == "all"){ T = "" }
        }
        
        self.showLoading()
        self.loadsCount += 1
        
        print("LOAD CONTROVERSY \(self.loadsCount)")
        ControversiesData.shared.loadList(topic: T, page: P) { (error, total, list, topics, controData) in

            self.hideLoading()
            if let _ = error {
                if(self.loadsCount >= 3) {
                    ALERT(vc: self, title: "Server error",
                        message: "Trouble loading Controversies,\nplease try again later.", onCompletion: {
                            CustomNavController.shared.popViewController(animated: true)
                    })
                } else {
                    print("Loading again...")
                    DELAY(0.5) {
                        self.loadContent(page: self.page)
                    }
                }
            } else {
                MAIN_THREAD {
                    if let _n = total, let _L = list, let _T = topics {
                        self.fillContent(total: _n, items: _L, topics: _T, controData: controData)
                    }
                }
            }
        }
                
    }
    
    func fillContent(total: Int, items: [ControversyListItem], topics: [SimpleTopic], controData: ControversyPortalData?) {
        let containerView = self.view.viewWithTag(555)!
        
        if(self.topics.count==0) {
            self.addTopics(topics)
        }
        
        REMOVE_ALL_SUBVIEWS(from: self.portalInfoView)
        /* Portal stuff */
        if let _controData = controData {
            let _W: CGFloat = IPHONE() ? (SCREEN_SIZE().width-32) : self.W()
            
            let portalView = UIView()
            portalView.backgroundColor = .clear //.green
            portalView.activateConstraints([
                portalView.widthAnchor.constraint(equalToConstant: _W)
            ])
            
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.font = DM_SERIF_DISPLAY_resize(22)
            titleLabel.textColor = CSS.shared.displayMode().main_textColor
            titleLabel.text = _controData.title
            
            let descrLabel = UILabel()
            descrLabel.numberOfLines = 0
            descrLabel.font = AILERON(14)
            descrLabel.textColor = CSS.shared.displayMode().sec_textColor
            descrLabel.text = _controData.description
            descrLabel.setLineSpacing(lineSpacing: 6.0)
            
            let graphView = self.createGraphView()
            
            if(IPHONE()) {
                let innerVStack = VSTACK(into: portalView)
                innerVStack.backgroundColor = .clear
                innerVStack.activateConstraints([
                    innerVStack.topAnchor.constraint(equalTo: portalView.topAnchor),
                    innerVStack.leadingAnchor.constraint(equalTo: portalView.leadingAnchor),
                    innerVStack.trailingAnchor.constraint(equalTo: portalView.trailingAnchor)
                ])
                
                innerVStack.addArrangedSubview(titleLabel)
                ADD_SPACER(to: innerVStack, height: 8)
                innerVStack.addArrangedSubview(descrLabel)
                ADD_SPACER(to: innerVStack, height: 8)
                
                let graphContainerView = UIView()
                graphContainerView.backgroundColor = .clear
                innerVStack.addArrangedSubview(graphContainerView)
                graphContainerView.activateConstraints([
                    graphContainerView.heightAnchor.constraint(equalToConstant: self.GRAPH_HEIGHT)
                ])
                
                graphContainerView.addSubview(graphView)
                graphView.activateConstraints([
                    graphView.centerXAnchor.constraint(equalTo: graphContainerView.centerXAnchor)
                ])

            } else {
                let innerHStack = HSTACK(into: portalView)
                innerHStack.backgroundColor = .clear
                innerHStack.activateConstraints([
                    innerHStack.topAnchor.constraint(equalTo: portalView.topAnchor),
                    innerHStack.leadingAnchor.constraint(equalTo: portalView.leadingAnchor),
                    innerHStack.trailingAnchor.constraint(equalTo: portalView.trailingAnchor)
                ])
                
                let innerVStack = VSTACK(into: innerHStack)
                innerVStack.backgroundColor = .clear
                innerVStack.addArrangedSubview(titleLabel)
                ADD_SPACER(to: innerVStack, height: 8)
                innerVStack.addArrangedSubview(descrLabel)
                ADD_SPACER(to: innerVStack)
                
                ADD_SPACER(to: innerHStack, width: 16)
                innerHStack.addArrangedSubview(graphView)
            }
            
            
            
            
        
            var H: CGFloat = 0
            
            if(IPHONE()) {
                H = titleLabel.calculateHeightFor(width: _W) + 8 +
                descrLabel.calculateHeightFor(width: _W) + 8 +
                self.GRAPH_HEIGHT
            } else {
                let _w: CGFloat = self.W() - 16 - self.GRAPH_HEIGHT
                let _h = titleLabel.calculateHeightFor(width: _w) + 8 + descrLabel.calculateHeightFor(width: _w)
                
                if(_h > self.GRAPH_HEIGHT) {
                    H = _h
                } else {
                    H = self.GRAPH_HEIGHT
                }
            }
            H += 16
        
            self.portalInfoView.addSubview(portalView)
            portalView.activateConstraints([
                portalView.heightAnchor.constraint(equalToConstant: H),
                portalView.centerXAnchor.constraint(equalTo: self.portalInfoView.centerXAnchor)
            ])
            self.portalInfoViewHeightConstraint?.constant = H
        
        

//            
//            let graphView = self.createGraphView()
//            
//            if(IPHONE()) {
//                self.portalInfoView.addArrangedSubview(titleLabel)
//                ADD_SPACER(to: self.portalInfoView, height: 8)
//                self.portalInfoView.addArrangedSubview(descrLabel)
//                ADD_SPACER(to: self.portalInfoView, height: 8)
//                self.portalInfoView.addArrangedSubview(graphView)
//            } else {
//                let innerHStack = HSTACK(into: self.portalInfoView)
//                innerHStack.backgroundColor = .clear
//                
//                let innerVStack = VSTACK(into: innerHStack)
//                innerVStack.backgroundColor = .clear //.green
//                innerVStack.addArrangedSubview(titleLabel)
//                ADD_SPACER(to: innerVStack, height: 8)
//                innerVStack.addArrangedSubview(descrLabel)
//                
//                ADD_SPACER(to: innerHStack, width: 16)
//                innerHStack.addArrangedSubview(graphView)
//                
//                //ADD_SPACER(to: innerHStack, backgroundColor: .yellow, width: 250)
//            }
//            
//            self.portalInfoViewHeightConstraint?.constant = 250+150
            self.portalInfoView.show()
            /* Portal stuff */
        } else {
            self.portalInfoView.hide()
        }
//        
//        print("ITEMS", self.portalInfoView.arrangedSubviews.count)
//        print("height", self.portalInfoViewHeightConstraint?.constant)
        
        var _items = items
//        for _ in 1...1 {
//            _items.remove(at: _items.count-1)
//        }
        
        for CO in _items {
            self.items.append(CO)
        }
        
        var col: CGFloat = 0
        var item_W: CGFloat = SCREEN_SIZE().width
        if(IPAD()){ item_W = (W()-M)/2 }
        var val_y: CGFloat = 0
        
        var col1: CGFloat = 0
        var col2: CGFloat = 0
        
        var index: Int = 0
        if(containerView.subviews.count > 0) {
            for V in containerView.subviews {
                if let _subView = V as? ControversyCellView {
                    if(IPHONE()) {
                        val_y += _subView.calculateHeight()
                        index += 1
                    } else {
                        if(col == 0) {
                            col1 += _subView.calculateHeight()
                        } else {
                            col2 += _subView.calculateHeight()
                        }
                        index += 1
                    
                        col += 1
                        if(col == 2) {
                            col = 0
                        }
                    }
                }
            }
            
            if(IPAD()) {
                val_y = (col1 > col2) ? col1 : col2
            }
        }
        
        
        for (_, CO) in _items.enumerated() {
            let controView = ControversyCellView(width: item_W)
            controView.buttonArea.hide()
            controView.tag = 600 + index
            if(containerView.subviews.count==0 && index==0 && IPHONE()){ controView.hideTopLine() }
            
            var val_x: CGFloat = col * item_W
            if(IPAD() && col==1) {
                val_x += M
            }
            
            var prev: ControversyCellView? = nil
            if(index>0) {
                if(IPHONE()) {
                    prev = (containerView.subviews.last as! ControversyCellView)
                } else { // IPAD
                    if(index==1) {
                        prev = (containerView.subviews.first as! ControversyCellView)
                    } else {
                        prev = (containerView.subviews[index-2] as! ControversyCellView)
                    }
                }
            }
            
            containerView.addSubview(controView)
            controView.activateConstraints([
                controView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: val_x),
                controView.widthAnchor.constraint(equalToConstant: item_W)
            ])
            
            if(index==0) {
                controView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: val_y).isActive = true
            } else {
            
                if(IPHONE()) {
                    controView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                } else { // IPAD
                    if(index==1) { // col2
                        let first = containerView.subviews.first as! ControversyCellView
                        controView.topAnchor.constraint(equalTo: first.topAnchor, constant: 0).isActive = true
                    } else {
                        controView.topAnchor.constraint(equalTo: prev!.bottomAnchor).isActive = true
                    }
                }
            }
            controView.populate(with: CO)
            
            if(col==0) {
                col1 += controView.calculateHeight()
            } else {
                col2 += controView.calculateHeight()
            }
            
            if(IPAD()) {
                col += 1
                if(col==2) {
                    col = 0
                    val_y += controView.calculateHeight()
                }
            } else {
                val_y += controView.calculateHeight()
            }
            
            if(index==self.items.count-1 && IPAD() && col==1) {
                val_y += controView.calculateHeight()
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(controversyOnTap(_:)))
            controView.addGestureRecognizer(tapGesture)
            
            index += 1
        }
        
        if(IPAD()) {
            val_y = (col1 > col2) ? col1 : col2
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
    @objc func controversyOnTap(_ gesture: UITapGestureRecognizer) {
        if let _view = gesture.view as? ControversyCellView {
            let index = _view.tag - 600
            
            let vc = ControDetailViewController()
            vc.slug = self.items[index].slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
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
                self.iPad_W -= IPAD_sideOffset()
            }
        
            return self.iPad_W
        }
    }
    
    func showMoreButton(_ visible: Bool) {
        if let moreView = self.view.viewWithTag(556) {
            if(visible) {
                self.showMoreViewHeightConstraint?.constant = 88
                moreView.show()
            } else {
                self.showMoreViewHeightConstraint?.constant = 0
                moreView.hide()
            }
        }
    }
    
}


extension ControversiesViewController {
    
    func addTopics(_ topics: [SimpleTopic]) {
        self.topics = topics
        
        let H: CGFloat = 40.0
        REMOVE_ALL_SUBVIEWS(from: self.topicsContainer)

        var _m: CGFloat = 0
        if(IPAD()) {
            _m = (SCREEN_SIZE_iPadSideTab().width - W())/2
        }
        
        let innerScrollView = UIScrollView()
        innerScrollView.showsHorizontalScrollIndicator = false
        innerScrollView.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.topicsContainer.addSubview(innerScrollView)
        innerScrollView.activateConstraints([
            innerScrollView.leadingAnchor.constraint(equalTo: self.topicsContainer.leadingAnchor, constant: _m),
            innerScrollView.trailingAnchor.constraint(equalTo: self.topicsContainer.trailingAnchor, constant: -_m),
            innerScrollView.topAnchor.constraint(equalTo: self.topicsContainer.topAnchor),
            innerScrollView.bottomAnchor.constraint(equalTo: self.topicsContainer.bottomAnchor)
        ])
        
        let innerContentView = UIView()
        innerContentView.backgroundColor = CSS.shared.displayMode().main_bgColor
        innerScrollView.addSubview(innerContentView)
        innerContentView.activateConstraints([
            innerContentView.leadingAnchor.constraint(equalTo: innerScrollView.leadingAnchor),
            innerContentView.topAnchor.constraint(equalTo: innerScrollView.topAnchor),
            innerContentView.heightAnchor.constraint(equalToConstant: H)
            //,innerContentView.widthAnchor.constraint(equalToConstant: 500)
        ])
        innerContentView.tag = 333
    
        let SEP: CGFloat = 8.0
        var val_x: CGFloat = IPHONE() ? M : 0
        for (i, T) in topics.enumerated() {
            let label = UILabel()
            label.font = AILERON(15)
            label.textColor = CSS.shared.displayMode().sec_textColor
            label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
            label.textAlignment = .center
            label.text = T.name
            label.layer.cornerRadius = 20
            label.layer.borderWidth = 1.0
            label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor
            label.clipsToBounds = true
            
            let _W = label.calculateWidthFor(height: H) + 42
            
            innerContentView.addSubview(label)
            label.activateConstraints([
                label.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: val_x),
                label.topAnchor.constraint(equalTo: innerContentView.topAnchor),
                label.widthAnchor.constraint(equalToConstant: _W),
                label.heightAnchor.constraint(equalToConstant: H)
            ])
            
            let button = UIButton(type: .custom)
            button.tag = 400 + i
            //button.backgroundColor = .red.withAlphaComponent(0.5)
            innerContentView.addSubview(button)
            button.activateConstraints([
                button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                button.topAnchor.constraint(equalTo: label.topAnchor),
                button.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            button.addTarget(self, action: #selector(topicButton_iPhoneOnTap(_:)), for: .touchUpInside)
            
            val_x += SEP + _W
        }

        if(IPHONE()) {
            val_x += M
        }

        innerContentView.widthAnchor.constraint(equalToConstant: val_x).isActive = true
        innerScrollView.contentSize = CGSize(width: val_x, height: H)
        
        ADD_SPACER(to: self.vStack, height: M*2)
        self.selectTopic_iPhone(index: 0, mustLoad: false)
    }
    @objc func topicButton_iPhoneOnTap(_ sender: UIButton) {
        let i = sender.tag - 400
        self.selectTopic_iPhone(index: i)
    }
    
    func selectTopic_iPhone(index: Int, mustLoad: Bool = true) {
        self.currentTopic = index
        
        if let containerView = self.view.viewWithTag(333) {
            var i = -1
            for V in containerView.subviews {
                if let label = V as? UILabel {
                    i += 1
                    if(i == index) {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
                        label.layer.borderColor = UIColor.clear.cgColor
                    } else {
                        label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                        label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor 
                    }
                }
            }
        }
        
        if(mustLoad) {
            //self.topics = []
            
            let containerView = self.view.viewWithTag(555)!
            REMOVE_ALL_SUBVIEWS(from: containerView)
            
            self.page = 1
            self.items = []
            self.loadsCount = 0
            self.loadContent(page: self.page)
        }
    }
    
    func refreshDisplayModeForTopics() {
        let C = CSS.shared.displayMode().main_bgColor
        
        self.topicsContainer.backgroundColor = C
        let scrollview = self.topicsContainer.subviews.first!
        scrollview.backgroundColor = C
        let contentView = scrollview.subviews.first!
        contentView.backgroundColor = C
        
        var count = 0
        for _v in contentView.subviews {
            if let _label = _v as? UILabel {
                _label.textColor = CSS.shared.displayMode().sec_textColor
                if(count == self.currentTopic) {
                    _label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2D2D31) : UIColor(hex: 0xE3E3E3)
                    _label.layer.borderColor = UIColor.clear.cgColor
                } else {
                    _label.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : UIColor(hex: 0xF0F0F0)
                    _label.layer.borderColor = DARK_MODE() ? UIColor(hex: 0x4C4E50).cgColor : UIColor(hex: 0xBBBDC0).cgColor
                }
                
                count += 1
            }
        }
    }
    
}

extension ControversiesViewController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        CustomNavController.shared.tour.rotate()
    }

}

extension ControversiesViewController {
    
    func createGraphView() -> UIView {
        let resultView = UIView()
        resultView.backgroundColor = .systemPink
        
        resultView.activateConstraints([
            resultView.widthAnchor.constraint(equalToConstant: self.GRAPH_HEIGHT),
            resultView.heightAnchor.constraint(equalToConstant: self.GRAPH_HEIGHT)
        ])
        
        return resultView
    }
    
}
