//
//  NavBarView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/09/2022.
//

import UIKit


enum NavBarViewComponents {
    case logo
    case menuIcon
    case searchIcon
    case back
    case backToFeed
    case title
    case share
    case user
    case closeModal
    case headlines
}


class NavBarView: UIView {

    var displayModeComponents = [Any]()
    
    private weak var viewController: UIViewController?
    private let buttonsMargin: CGFloat = 5.0
    private var left_x: CGFloat = 15
    private var right_x: CGFloat = 15
    
    private var shareUrl: String? = nil
    private weak var vc: UIViewController? = nil
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(viewController: UIViewController) {
        self.viewController = viewController
        let container = viewController.view!
    
        self.backgroundColor = .red
        container.addSubview(self)
        self.activateConstraints([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: Y_TOP_NOTCH_FIX(101)),
        ])
        self.refreshDisplayMode()
    }
    
    func addComponents(_ components: [NavBarViewComponents]) {
        for C in components {
            if(C == .logo) {
//                // ITN logo
//                let logo = UIImageView(image: UIImage(named: ("navBar.circleLogo")))
//                self.addSubview(logo)
//                logo.activateConstraints([
//                    logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//                    logo.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(50)),
//                    logo.widthAnchor.constraint(equalToConstant: 44),
//                    logo.heightAnchor.constraint(equalToConstant: 44)
//                ])
//                logo.tag = 1
//                self.displayModeComponents.append(logo)
//
//                let button = UIButton(type: .system)
//                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
//                self.addSubview(button)
//                button.activateConstraints([
//                    button.leadingAnchor.constraint(equalTo: logo.leadingAnchor, constant: -self.buttonsMargin),
//                    button.topAnchor.constraint(equalTo: logo.topAnchor, constant: -self.buttonsMargin),
//                    button.widthAnchor.constraint(equalTo: logo.widthAnchor, constant: self.buttonsMargin * 2),
//                    button.heightAnchor.constraint(equalTo: logo.heightAnchor, constant: self.buttonsMargin * 2)
//                ])
//                button.addTarget(self, action: #selector(onLogoButtonTap(_:)), for: .touchUpInside)
                // VERITY logo
                let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verity.logo")))
                self.addSubview(logo)
                logo.activateConstraints([
                    logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    logo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                    //logo.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(50)),
                    logo.widthAnchor.constraint(equalToConstant: 475 * 0.23),
                    logo.heightAnchor.constraint(equalToConstant: 97 * 0.23)
                ])
                //logo.backgroundColor = .red.withAlphaComponent(0.5)
                logo.tag = 1
                self.displayModeComponents.append(logo)

                let button = UIButton(type: .system)
                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: logo.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: logo.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: logo.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: logo.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onLogoButtonTap(_:)), for: .touchUpInside)
            }
            
            if(C == .menuIcon) {
                // Menu
                let menuIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.menu")))
                self.addSubview(menuIcon)
                menuIcon.activateConstraints([
                    menuIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x),
                    menuIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    menuIcon.widthAnchor.constraint(equalToConstant: 24),
                    menuIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                menuIcon.tag = 2
                self.displayModeComponents.append(menuIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: menuIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: menuIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: menuIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: menuIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onMenuButtonTap(_:)), for: .touchUpInside)
                
                self.left_x += 24 + 15
            }
            
            if(C == .searchIcon) {
                // Search
                let searchIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.search")))
                self.addSubview(searchIcon)
                searchIcon.activateConstraints([
                    searchIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    searchIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    searchIcon.widthAnchor.constraint(equalToConstant: 24),
                    searchIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                searchIcon.tag = 3
                self.displayModeComponents.append(searchIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: searchIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: searchIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: searchIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onSearchButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 24 + 15
            }
            
            if(C == .backToFeed) {
                self.left_x -= 10
                // Back to feed (from the article content)
                let backIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("back.button")))
                self.addSubview(backIcon)
                backIcon.activateConstraints([
                    backIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x),
                    backIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    backIcon.widthAnchor.constraint(equalToConstant: 24),
                    backIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                backIcon.tag = 4
                self.displayModeComponents.append(backIcon)
                
                let merriweather_bold = MERRIWEATHER_BOLD(18)
                
                let label = UILabel()
                label.text = "Back to feed"
                label.textColor = .black
                label.font = merriweather_bold
                self.addSubview(label)
                label.activateConstraints([
                    label.leadingAnchor.constraint(equalTo: backIcon.trailingAnchor, constant: 3),
                    label.centerYAnchor.constraint(equalTo: backIcon.centerYAnchor)
                ])
                label.tag = 5
                self.displayModeComponents.append(label)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: backIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: backIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalToConstant: 150),
                    button.heightAnchor.constraint(equalTo: backIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onBackButtonTap(_:)), for: .touchUpInside)
                
                self.left_x += 24 + 110 + 15
            }
            
            if(C == .title) {
                let merriweather_bold = MERRIWEATHER_BOLD(18)
                
                let label = UILabel()
                label.text = " "
                label.textColor = .black
                label.backgroundColor = .clear //.red.withAlphaComponent(0.25)
                label.font = merriweather_bold
                self.addSubview(label)
                label.activateConstraints([
                    label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    label.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                ])
                label.tag = 7
                self.displayModeComponents.append(label)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -20),
                    button.topAnchor.constraint(equalTo: label.topAnchor, constant: -self.buttonsMargin),
                    button.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
                    button.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: self.buttonsMargin)
                ])
                button.addTarget(self, action: #selector(onTitleButtonTap(_:)), for: .touchUpInside)
            }
            
            if(C == .back) {
                self.left_x -= 10
                // Back
                let backIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("back.button")))
                self.addSubview(backIcon)
                backIcon.activateConstraints([
                    backIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x),
                    backIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    backIcon.widthAnchor.constraint(equalToConstant: 24),
                    backIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                backIcon.tag = 6
                self.displayModeComponents.append(backIcon)

                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: backIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: backIcon.topAnchor, constant: -self.buttonsMargin),
                    button.trailingAnchor.constraint(equalTo: backIcon.trailingAnchor, constant: self.buttonsMargin),
                    button.bottomAnchor.constraint(equalTo: backIcon.bottomAnchor, constant: self.buttonsMargin)
                ])
                button.addTarget(self, action: #selector(onBackButtonTap(_:)), for: .touchUpInside)
                
                self.left_x += 24 + 15
            }
            
            if(C == .share) {
                // Search
                let shareIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("share")))
                self.addSubview(shareIcon)
                shareIcon.activateConstraints([
                    shareIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    shareIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    shareIcon.widthAnchor.constraint(equalToConstant: 24),
                    shareIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                shareIcon.tag = 8
                self.displayModeComponents.append(shareIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: shareIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: shareIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: shareIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: shareIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onShareButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 24 + 15
            }
            
            if(C == .user) {
                // User
                let userIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.user")))
                self.addSubview(userIcon)
                userIcon.activateConstraints([
                    userIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    userIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    userIcon.widthAnchor.constraint(equalToConstant: 24),
                    userIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                userIcon.tag = 9
                self.displayModeComponents.append(userIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: userIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: userIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: userIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: userIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onUserButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 24 + 15
            }
            
            if(C == .closeModal) {
                // Close a modal
                let closeIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("popup.close")))
                self.addSubview(closeIcon)
                closeIcon.activateConstraints([
                    closeIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    closeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    closeIcon.widthAnchor.constraint(equalToConstant: 24),
                    closeIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                closeIcon.tag = 10
                self.displayModeComponents.append(closeIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: closeIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: closeIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onCloseModalButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 24 + 15
            }
            
            if(C == .headlines) {
                // Back to headlines
                let ITNicon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.home")))
                self.addSubview(ITNicon)
                ITNicon.activateConstraints([
                    ITNicon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    ITNicon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(60)),
                    ITNicon.widthAnchor.constraint(equalToConstant: 24),
                    ITNicon.heightAnchor.constraint(equalToConstant: 24)
                ])
                //ITNicon.tag = 10
                self.displayModeComponents.append(ITNicon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: ITNicon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: ITNicon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: ITNicon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: ITNicon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onHeadlinesButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 24 + 15
            }
        }
        
        self.refreshDisplayMode()
    }
    
    // MARK: - misc
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x19191C) : .white
        
        for C in self.displayModeComponents {
        
            if(C is UIImageView) {
                
                let imgView = C as! UIImageView
                var img: UIImage?
                
                switch(imgView.tag) {
                    case 1: // logo
                        //imgView.image = UIImage(named: DisplayMode.imageName("navBar.circleLogo"))
                        img = UIImage(named: DisplayMode.imageName("verity.logo"))?.withRenderingMode(.alwaysTemplate)
                    case 2: // menu
                        img = UIImage(named: DisplayMode.imageName("navBar.menu"))?.withRenderingMode(.alwaysTemplate)
                    case 3: // search
                        img = UIImage(named: DisplayMode.imageName("navBar.search"))?.withRenderingMode(.alwaysTemplate)
                    case 4: // back (+ text)
                        img = UIImage(named: DisplayMode.imageName("back.button"))?.withRenderingMode(.alwaysTemplate)
                    case 6: // back
                        img = UIImage(named: DisplayMode.imageName("back.button"))?.withRenderingMode(.alwaysTemplate)
                    case 8: // share
                        img = UIImage(named: DisplayMode.imageName("share"))?.withRenderingMode(.alwaysTemplate)
                    case 9: // user
                        img = UIImage(named: DisplayMode.imageName("navBar.user"))?.withRenderingMode(.alwaysTemplate)
                    case 10: // close
                        img = UIImage(named: DisplayMode.imageName("popup.close"))?.withRenderingMode(.alwaysTemplate)
                    
                    default:
                        NOTHING()
                }
                
                imgView.image = img
                if(imgView.tag==1) { // logo
                    imgView.tintColor = DARK_MODE() ? .white : UIColor(hex: 0x0A0A0C)
                } else {
                    imgView.tintColor = DARK_MODE() ? UIColor(hex: 0xBBBDC0) : UIColor(hex: 0x0A0A0C)
                }
                
            }
            
            if(C is UILabel) {
                let label = C as! UILabel
                switch(label.tag) {
                    case 5: // BACK TO FEED
                        label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
                    case 7: // TITLE
                        label.textColor = DARK_MODE() ? .white : UIColor(hex: 0x1D242F)
                        
                    default:
                        NOTHING()
                }
            }
        }
    }
    
    func setTitle(_ text: String) {
        if let _label = self.viewWithTag(7) as? UILabel {
            _label.text = text
        }
    }
    
    func setShareUrl(_ url: String, vc: UIViewController) {
        self.shareUrl = url
        self.vc = vc
    }

}

// MARK: - UI Fixes
extension NavBarView {

    static func HEIGHT() -> CGFloat {
        return Y_TOP_NOTCH_FIX(101)
    }
    
}

// MARK: - Event(s)
extension NavBarView {
    
    @objc func onMenuButtonTap(_ sender: UIButton) {
        CustomNavController.shared.showMenu()        
    }
    
    @objc func onBackButtonTap(_ sender: UIButton) {
        CustomNavController.shared.popViewController(animated: true)
    }
    
    @objc func onLogoButtonTap(_ sender: UIButton) {
//        if let _vc = self.viewController as? MainFeedViewController {
//            _vc.tapOnLogo()
//            //_vc.scrollToZero()
//        }

        if(CustomNavController.shared.presentedViewController != nil) {
            CustomNavController.shared.dismiss(animated: true)
        }

        CustomNavController.shared.menu.gotoHeadlines(delayTime: 0)
    }
    
    @objc func onSearchButtonTap(_ sender: UIButton) {
//        let vc = SearchViewController()
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        CustomNavController.shared.tour?.cancel()
//        CustomNavController.shared.present(vc, animated: true)

        let vc = KeywordSearchViewController()
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func onShareButtonTap(_ sender: UIButton) {
        if let _url = self.shareUrl, let _vc = self.vc {
            SHARE_URL(_url, from: _vc)
        }
    }
    
    @objc func onTitleButtonTap(_ sender: UIButton) {
        if let _vc = CustomNavController.shared.viewControllers.last as? MainFeedViewController {
            _vc.scrollToZero()
        }
    }
    
    @objc func onUserButtonTap(_ sender: UIButton) {
        var vc: UIViewController?
        
        if(USER_AUTHENTICATED()) {
            vc = AccountViewController()
        } else {
            vc = SignInUpViewController()
        }
        
        CustomNavController.shared.pushViewController(vc!, animated: true)
    }
    
    @objc func onCloseModalButtonTap(_ sender: UIButton) {
        CustomNavController.shared.dismiss(animated: true)
    }
    
    @objc func onHeadlinesButtonTap(_ sender: UIButton) {
        CustomNavController.shared.menu.gotoHeadlines(delayTime: 0)
    }
    
    
}
