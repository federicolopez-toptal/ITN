//
//  MenuView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import UIKit

class MenuView: UIView {

    var MENU_WIDTH: CGFloat = CSS.shared.menu_width

    var menuLeadingConstraint: NSLayoutConstraint?
    var list = UITableView()
    var versionLabel = UILabel()
    var logo = UIImageView()
    
    var isShowingMore = false
    
    var dataProvider = [MenuITem]()
    
    let dataProvider_A: [MenuITem] = [ // Items order
        .headlines,
        .profile,
        .displayMode,
        .tour,
        .preferences,
        .layout,
        .faq,
        .logout,

        .more
    ]
    
    let dataProvider_B: [MenuITem] = [ // Items order
        .headlines,
        .profile,
        .displayMode,
        .tour,
        .preferences,
        .layout,
        .faq,
        .logout,
        .more,
        
        .sliders,
        .feedback,
        .privacy
    ]
    
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
        if(IPAD()){ MENU_WIDTH = 340 }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ container: UIView) {
        container.addSubview(self)
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.menuLeadingConstraint = self.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        self.activateConstraints([
            self.menuLeadingConstraint!,
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            self.widthAnchor.constraint(equalToConstant: self.MENU_WIDTH)
        ])
        
        let topSpace: CGFloat = Y_TOP_NOTCH_FIX(54)
        var bottomSpace: CGFloat = 30
        if let _extraSpace = SAFE_AREA()?.bottom {
            bottomSpace += _extraSpace * 0.6
        }
        
        self.addSubview(self.list)
        self.list.backgroundColor = self.backgroundColor
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.list.topAnchor.constraint(equalTo: self.topAnchor, constant: topSpace + 45),
            self.list.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomSpace-25)
        ])
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.list.delegate = self
        self.list.dataSource = self
        self.list.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        
        let vInfo = "V. " + Bundle.main.releaseVersionNumber! +
            " (" + Bundle.main.buildVersionNumber! + ")"
        
        self.addSubview(self.versionLabel)
        self.versionLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)
        //self.versionLabel.backgroundColor = .yellow.withAlphaComponent(0.2)
        self.versionLabel.font =  AILERON(13)
        self.versionLabel.text = vInfo
        self.versionLabel.textAlignment = .right
        self.versionLabel.activateConstraints([
            //self.versionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.versionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.versionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomSpace)
        ])
        
        self.logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verity.logo")))
        self.addSubview(self.logo)
        self.logo.activateConstraints([
            self.logo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomSpace),
            self.logo.widthAnchor.constraint(equalToConstant: 115),
            self.logo.heightAnchor.constraint(equalToConstant: 23.42),
            self.logo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 41)
        ])
        
        let closeImage = UIImage(named: DisplayMode.imageName("circle.close"))
        let closeIcon = UIImageView(image: closeImage)
        closeIcon.tag = 77
        self.addSubview(closeIcon)
        closeIcon.activateConstraints([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: topSpace)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.addSubview(closeButton)
        closeButton.activateConstraints([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
        
        // -------------------
        self.menuLeadingConstraint?.constant = -self.MENU_WIDTH
        
        self.dataProvider = self.dataProvider_A
        self.removeLogoutIfApply()
        
        self.refreshDisplayMode()
    }
    
    // MARK: - misc
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.list.backgroundColor = self.backgroundColor
        
        for (i, _) in self.dataProvider.enumerated() {
            let cell = self.tableView(self.list, cellForRowAt: IndexPath(row: i, section: 0)) as! MenuItemCell
            cell.refreshDisplayMode()
        }

        let closeIcon = self.viewWithTag(77) as! UIImageView
        closeIcon.image = UIImage(named: DisplayMode.imageName("circle.close"))
        
        //closeIcon.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
        self.versionLabel.textColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x19191C)

        self.logo.image = UIImage(named: DisplayMode.imageName("verity.logo"))
        self.list.reloadData()
    }
    
    private func dismissMe() {
        self.refreshDisplayMode()
        CustomNavController.shared.dismissMenu()
    }

}

// MARK: - Event(s)
extension MenuView {
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    // ---------
    func gotoHeadlines(delayTime: TimeInterval = 0.5) {
        self.dismissMe()
        
        if(IPHONE()) {
            var firstIsMainFeed = false
            if let firstVC = CustomNavController.shared.viewControllers.first as? MainFeedViewController {
                if(firstVC.topic == "news"){ firstIsMainFeed = true }
            }
            if let firstVC = CustomNavController.shared.viewControllers.first as? MainFeed_v3_viewController {
                if(firstVC.topic == "news"){ firstIsMainFeed = true }
            }
            
            if(firstIsMainFeed) {
                DELAY(delayTime) {
                    let count = CustomNavController.shared.viewControllers.count
                
                    if(count==1) {
                        self.gotoHeadlines_B()
                    } else {
                        CustomNavController.shared.popToRootViewController(animated: true)
                        DELAY(0.3) {
                            self.gotoHeadlines_B()
                        }
                    }
                }
            } else {
                let vc = NAV_MAINFEED_VC()
                CustomNavController.shared.viewControllers = [vc]
                
                DELAY(0.2) {
                    self.dismissMe()
                    CustomNavController.shared.slidersPanel.show()
                    CustomNavController.shared.floatingButton.show()
                }
            }
        } else {
            var firstIsMainFeed = false
            if let firstVC = CustomNavController.shared.viewControllers.first as? MainFeed_v2ViewController {
                if(firstVC.topic == "news"){ firstIsMainFeed = true }
            }
            
            if(firstIsMainFeed) {
                DELAY(delayTime) {
                    let count = CustomNavController.shared.viewControllers.count
                
                    if(count==1) {
                        self.gotoHeadlines_B()
                    } else {
                        CustomNavController.shared.popToRootViewController(animated: true)
                        DELAY(0.3) {
                            self.gotoHeadlines_B()
                        }
                    }
                }
            } else {
                let vc = MainFeed_v2ViewController()
                CustomNavController.shared.viewControllers = [vc]
                
                DELAY(0.2) {
                    self.dismissMe()
                    CustomNavController.shared.slidersPanel.show()
                    CustomNavController.shared.floatingButton.show()
                }
            }
        }
    }
    private func gotoHeadlines_B() {
        if(IPHONE()) {
            if let _vc = CustomNavController.shared.viewControllers.first as? MainFeedViewController {
                _vc.scrollToZero()
            }
            if let _vc = CustomNavController.shared.viewControllers.first as? MainFeed_v3_viewController {
                _vc.list.scrollToTop()
            }
        } else {
            if let _vc = CustomNavController.shared.viewControllers.first as? MainFeed_v2ViewController {
                _vc.scrollToZero()
            }
        }
    }
    
    // ---------
    func presentPreferences() {
        self.dismissMe()
        CustomNavController.shared.hidePanelAndButtonWithAnimation()

        DELAY(0.5) {
            let vc = PreferencesViewController()
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    // ---------
    func changeDisplayModeFromStoredValue() {
        CustomNavController.shared.refreshDisplayMode()
        self.refreshDisplayMode()
        
        var stored = "0"
        if let _stored = READ(LocalKeys.preferences.displayMode) {
            stored = _stored
        }
        
        if(stored=="0" && DisplayMode.current() == .bright) {
            self.changeDisplayMode()
        } else if(stored=="1" && DisplayMode.current() == .dark) {
            self.changeDisplayMode()
        }

    }
    // ---------
    func changeDisplayMode() {
        var changeTo: DisplayMode = .bright
        if(DisplayMode.current() == .bright) {
            changeTo = .dark
        }

        var newValue = "0"
        if(changeTo == .bright){ newValue = "1" }
        WRITE(LocalKeys.preferences.displayMode, value: newValue)

        CustomNavController.shared.refreshDisplayMode()
        //NOTIFY(Notification_reloadMainFeed)
        self.dismissMe()
    }
    
    // ---------
    func changeLayoutFromStoredValue() {
        var stored = "0"
        if let _stored = READ(LocalKeys.preferences.layout) {
            stored = _stored
        }
        
        if(stored=="0" && Layout.current() == .textOnly) {
            self.changeLayout()
        } else if(stored=="1" && Layout.current() == .textImages) {
            self.changeLayout()
        }
    }
    // ---------
    func changeLayout() {
        var changeTo: Layout = .textOnly
        if(Layout.current() == .textOnly) {
            changeTo = .textImages
        }
        
        var newValue = "0"
        if(changeTo == .textOnly){ newValue = "1" }
        WRITE(LocalKeys.preferences.layout, value: newValue)
        API.shared.savesSliderValues( MainFeedv3.sliderValues() )
        NOTIFY(Notification_reloadMainFeed)

        
        if(IPHONE()) {
            var firstIsMainFeed = false
            firstIsMainFeed = CustomNavController.shared.viewControllers.first! is MainFeedViewController
            if(!firstIsMainFeed){ firstIsMainFeed = CustomNavController.shared.viewControllers.first! is MainFeed_v3_viewController }
            
            if(firstIsMainFeed) {
                self.dismissMe()
            } else {
                let vc = NAV_MAINFEED_VC()
                CustomNavController.shared.viewControllers = [vc]
                
                DELAY(0.2) {
                    self.dismissMe()
                    CustomNavController.shared.slidersPanel.show()
                    CustomNavController.shared.floatingButton.show()
                }
            }
        } else {
            let firstIsMainFeed = CustomNavController.shared.viewControllers.first! is MainFeed_v2ViewController
            if(firstIsMainFeed) {
                self.dismissMe()
            } else {
                let vc = MainFeed_v2ViewController()
                CustomNavController.shared.viewControllers = [vc]
                
                DELAY(0.2) {
                    self.dismissMe()
                    CustomNavController.shared.slidersPanel.show()
                    CustomNavController.shared.floatingButton.show()
                }
            }
        }
    }
    
    // ---------
    func startTour() {
        CustomNavController.shared.showTour = true
        CustomNavController.shared.slidersPanel.makeSureIsClosed()
        CustomNavController.shared.slidersPanel.forceSplitOff()
        
        if(IPHONE()) {
            let vc = NAV_MAINFEED_VC()
            CustomNavController.shared.viewControllers = [vc]
        } else {
            let vc = MainFeed_v2ViewController()
            CustomNavController.shared.viewControllers = [vc]
        }
        
        DELAY(0.3) {
            self.dismissMe()
        }
    }
    
    // ---------
    func showMore() {
        self.isShowingMore = !self.isShowingMore
        
        if(self.isShowingMore) {
            self.dataProvider = self.dataProvider_B
        } else {
            self.dataProvider = self.dataProvider_A
        }
        
        self.removeLogoutIfApply()
        self.refreshDisplayMode() // reload list implicit
    }
    
    // ---------
    func showContent(_ item: MenuITem) {
        self.dismissMe()
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
        
        switch(item) {
            case .sliders:
                let vc = PreferencesViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
                DELAY(0.3) {
                    vc.scrollToSliders()
                }

            // -----
            case .faq:
                let vc = FAQViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            
            case .feedback:
                let vc = FeedbackFormViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)
            
            case .privacy:
                let vc = PrivacyPolicyViewController()
                CustomNavController.shared.pushViewController(vc, animated: true)

            default:
                NOTHING()
        }
    }
    
    // ---------
    func showProfile() {
        self.dismissMe()
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    
        var vc: UIViewController?
        if(USER_AUTHENTICATED()) {
            vc = AccountViewController()
        } else {
            vc = SignInUpViewController()
        }
        
        CustomNavController.shared.pushViewController(vc!, animated: true)
    }
    
    // ---------
    func askForLogout() {
        let msg = "Are you sure you want to sign out\nfrom your account?"
        CustomNavController.shared.ask(question: msg) { (success) in
            if(success) {
                WRITE(LocalKeys.preferences.sourceFilters, value: "")
                WRITE(LocalKeys.user.AUTHENTICATED, value: "NO")
                CustomNavController.shared.menu.updateLogout()

                self.resetAllSettings()
                NOTIFY(Notification_reloadMainFeed)
                CustomNavController.shared.slidersPanel.reloadSliderValues()
                CustomNavController.shared.slidersPanel.forceSplitOff()
                
                if(Layout.current() == .textOnly) {
                    self.changeLayout()
                }
                
                if(DisplayMode.current() == .bright) {
                    self.changeDisplayMode()
                }
                
                self.dismissMe()
            }
        }
    }
    
    private func resetAllSettings() {
        // Back all settings to default
        
        // Sliders
        for (i, key) in LocalKeys.sliders.allKeys.enumerated() {
            var newValue = LocalKeys.sliders.defaultValues[i]
            let strValue = String(format: "%02d", newValue)
            WRITE(key, value: strValue)
        }
        
        // Feed Preferences (on/off)
        WRITE(LocalKeys.preferences.showSourceFlags, value: "01")
        WRITE(LocalKeys.preferences.showSourceIcons, value: "01")
        WRITE(LocalKeys.preferences.showStanceIcons, value: "01")
        WRITE(LocalKeys.preferences.showStories, value: "01")
    }
    
}

// MARK: - UITableView
extension MenuView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.list.dequeueReusableCell(withIdentifier: MenuItemCell.identifier) as! MenuItemCell
        let dpItem = self.dataProvider[indexPath.row]
        
        let text = self.getText(forItem: dpItem)
        cell.titleLabel.text = text
        
        cell.titleLabel.font = CSS.shared.menu_font
//        if(text == self.getText(forItem: .sliders)) {
//            cell.titleLabel.font = AILERON(13.5)
//        }
        
        cell.titleLabel.addCharacterSpacing(kernValue: 1.0)
        //cell.titleLabel.backgroundColor = .systemPink
        cell.icon.image = self.getIcon(forItem: dpItem)
        cell.icon.tintColor = CSS.shared.displayMode().menuItem_color
        
        var gap: CGFloat = 0
        if(!self.dataProvider_A.contains(dpItem)) {
            gap = 37
        }
        cell.setLeftGap(gap)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuItemCell.heigth
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataProvider[indexPath.row]
        self.tapOnItem(item)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = self.dataProvider[indexPath.row]
        var animation: Animation?
        
        // Animation (only for subitems in "more")
        if(self.isShowingMore) {
            if(!self.dataProvider_A.contains(item)) {
                animation = AnimationFactory.makeMoveDownWithFade(rowHeight: MenuItemCell.heigth, duration: 0.35, delayFactor: 0)
            }
        }
        
        if let _animation = animation {
            let animator = Animator(animation: _animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
        
    }
    
}


// MARK: - Logout
extension MenuView {
    
    func removeLogoutIfApply() {
        if(!USER_AUTHENTICATED()) {
            for (i, item) in self.dataProvider.enumerated() {
                if(item == .logout) {
                    self.dataProvider.remove(at: i)
                    break
                }
            }
        }
    }
    
    func updateLogout() {
        if(self.isShowingMore) {
            self.dataProvider = self.dataProvider_B
        } else {
            self.dataProvider = self.dataProvider_A
        }
        
        self.removeLogoutIfApply()
        self.refreshDisplayMode() // reload list implicit
    }
    
    
    
}
