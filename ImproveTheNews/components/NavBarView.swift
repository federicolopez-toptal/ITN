//
//  NavBarView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 06/09/2022.
//

import UIKit


enum NavBarViewComponents {
    case back
    case customBack
    case backToFeed

    case logo
    case menuIcon
    case searchIcon
    case title
    case longTitle
    case share
    case user
    case headlines
    case question
    case info
    
    case newsletter
}


class NavBarView: UIView {

    var displayModeComponents = [Any]()
    
    private weak var viewController: UIViewController?
    private let buttonsMargin: CGFloat = 5.0
    private var left_x: CGFloat = CSS.shared.iPhoneSide_padding
    private var right_x: CGFloat = CSS.shared.iPhoneSide_padding
    
    private var shareUrl: String? = nil
    private weak var vc: UIViewController? = nil
    
    var longTitleHSpace: CGFloat = 0
    var longTitleTrailingConstraint: NSLayoutConstraint?
    var longTitleTrailingValue_long: CGFloat = 0
    var longTitleTrailingValue_short: CGFloat = 0

    var bottomLine: UIView?

    var questionAction: ( () -> Void )? = nil
    var infoAction: ( () -> Void )? = nil
    var shareAction: ( () -> Void )? = nil


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

        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        container.addSubview(self)
        self.activateConstraints([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: IPAD_sideOffset()),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_height)),
        ])
        self.refreshDisplayMode()
    }
    
    func addBottomLine() {
        self.bottomLine = UIView()
        self.bottomLine!.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        self.addSubview(self.bottomLine!)
        self.bottomLine!.activateConstraints([
            self.bottomLine!.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.bottomLine!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bottomLine!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomLine!.heightAnchor.constraint(equalToConstant: 1)
        ])
        ADD_HDASHES(to: self.bottomLine!)
    }
    
    func addComponents(_ components: [NavBarViewComponents]) {
        for C in components {
            if(C == .logo) {
                // VERITY logo
                let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("verity.logo")))
                self.addSubview(logo)
                logo.activateConstraints([
                    logo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                    logo.widthAnchor.constraint(equalToConstant: 115),
                    logo.heightAnchor.constraint(equalToConstant: 23.42),
                    logo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64)
                ])
                
                logo.tag = 1
                self.displayModeComponents.append(logo)

                let button = UIButton(type: .system)
                button.backgroundColor = .clear
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
                let menuIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("newNavBar.menu")))
                self.addSubview(menuIcon)
                menuIcon.activateConstraints([
                    menuIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x),
                    menuIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    menuIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    menuIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
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
                
                self.left_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .searchIcon) {
                // Search
                let searchIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("newNavBar.search")))
                self.addSubview(searchIcon)
                searchIcon.activateConstraints([
                    searchIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    searchIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    searchIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    searchIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
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
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .user) {
                // User
                let userIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("newNavBar.user")))
                self.addSubview(userIcon)
                userIcon.activateConstraints([
                    userIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    userIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    userIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    userIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
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
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .backToFeed) {
                self.left_x -= 10
                // Back to feed (from the article content)
                let backIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.back")))
                self.addSubview(backIcon)
                backIcon.activateConstraints([
                    backIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x+10),
                    backIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    backIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    backIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                backIcon.tag = 4
                self.displayModeComponents.append(backIcon)
                
                let label = UILabel()
                label.text = "Back to feed"
                label.textColor = .black
                label.font = CSS.shared.iPhoneTitleBar_font
                self.addSubview(label)
                label.activateConstraints([
                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 64),
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
                
                self.left_x += CSS.shared.navBar_icon_size + 110 + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .back) {
                self.left_x -= 10
                // Back
                let backIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.back")))
                self.addSubview(backIcon)
                backIcon.activateConstraints([
                    backIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x+10),
                    backIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    backIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    backIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
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
                
                self.left_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .customBack) {
                self.left_x -= 10
                // Back
                let backIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.back")))
                self.addSubview(backIcon)
                backIcon.activateConstraints([
                    backIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x+10),
                    backIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    backIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    backIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
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
                button.addTarget(self, action: #selector(onCustomBackButtonTap(_:)), for: .touchUpInside)
                
                self.left_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .share) {
                // Search
                let shareIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.share")))
                self.addSubview(shareIcon)
                shareIcon.activateConstraints([
                    shareIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    shareIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    shareIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    shareIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
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
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .question) {
                // Search
                let questionIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("question")))
                self.addSubview(questionIcon)
                questionIcon.activateConstraints([
                    questionIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    questionIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    questionIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    questionIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                questionIcon.tag = 12
                self.displayModeComponents.append(questionIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: questionIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: questionIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: questionIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: questionIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onQuestionButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .info) {
                // Search
                let infoIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("info")))
                self.addSubview(infoIcon)
                infoIcon.activateConstraints([
                    infoIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    infoIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    infoIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    infoIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                infoIcon.tag = 13
                self.displayModeComponents.append(infoIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: infoIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: infoIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: infoIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: infoIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onInfoButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .headlines) {
                // Back to headlines
                let ITNicon = UIImageView(image: UIImage(named: DisplayMode.imageName("circle.home")))
                self.addSubview(ITNicon)
                ITNicon.activateConstraints([
                    ITNicon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    ITNicon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    ITNicon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    ITNicon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                ITNicon.tag = 10
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
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .title) {
                self.left_x += 5
                var offset: CGFloat = self.left_x
                if(self.right_x > offset){ offset = self.right_x }
            
                let label = UILabel()
                label.text = " "
                label.textColor = .black
                label.textAlignment = .center
                //label.backgroundColor = .red.withAlphaComponent(0.25)
                label.font = CSS.shared.iPhoneTitleBar_font
                self.addSubview(label)
                label.activateConstraints([
                    label.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: IPAD_sideOffset(multiplier: -0.5))
//                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: offset),
//                    label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset),
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
            
            if(C == .longTitle) {
                self.left_x += 10
                
                let label = UILabel()
                label.text = " "
                label.textColor = .black
                label.textAlignment = .center
                //label.backgroundColor = .green.withAlphaComponent(0.25)
                label.font = CSS.shared.iPhoneTitleBar_font
                self.addSubview(label)
                label.activateConstraints([
                    label.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    label.heightAnchor.constraint(equalToConstant: 32),
                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x)
                ])
                
                self.longTitleTrailingValue_long = -self.right_x
                self.longTitleTrailingValue_short = -self.left_x
                
                self.longTitleTrailingConstraint = label.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                    constant: -self.right_x)
                self.longTitleTrailingConstraint?.isActive = true
                
                label.tag = 11
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
                
                self.longTitleHSpace = SCREEN_SIZE().width - self.left_x - self.right_x
                
                self.sendSubviewToBack(button)
                self.sendSubviewToBack(label)
            }
            
            if(C == .newsletter && IPHONE()) {
                // Newsletter subscription
                let newsletterIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("newNavBar.newsletter")))
                self.addSubview(newsletterIcon)
                newsletterIcon.activateConstraints([
                    newsletterIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    newsletterIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    newsletterIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    newsletterIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                newsletterIcon.tag = 14
                self.displayModeComponents.append(newsletterIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: newsletterIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: newsletterIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: newsletterIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: newsletterIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onNewsletterButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += CSS.shared.navBar_icon_size + CSS.shared.navBar_icon_sepX
            }
            
            if(C == .newsletter && IPAD()) {
                // Newsletter subscription
                let colorView = UIView()
                colorView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : UIColor(hex: 0xe3e3e3)
                self.addSubview(colorView)
                colorView.activateConstraints([
                    colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    colorView.topAnchor.constraint(equalTo: self.topAnchor, constant: Y_TOP_NOTCH_FIX(CSS.shared.navBar_icon_posY)),
                    colorView.widthAnchor.constraint(equalToConstant: 138),
                    colorView.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                colorView.layer.cornerRadius = CSS.shared.navBar_icon_size/2
                
                let newsletterIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("newNavBar.newsletter")))
                colorView.addSubview(newsletterIcon)
                newsletterIcon.activateConstraints([
                    newsletterIcon.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 8),
                    newsletterIcon.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
                    newsletterIcon.widthAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size),
                    newsletterIcon.heightAnchor.constraint(equalToConstant: CSS.shared.navBar_icon_size)
                ])
                newsletterIcon.tag = 14
                self.displayModeComponents.append(newsletterIcon)

                let newsletterLabel = UILabel()
                newsletterLabel.text = "Newsletters"
                newsletterLabel.font = AILERON(15)
                newsletterLabel.tag = 99
                colorView.addSubview(newsletterLabel)
                newsletterLabel.activateConstraints([
                    newsletterLabel.centerYAnchor.constraint(equalTo: colorView.centerYAnchor),
                    newsletterLabel.leadingAnchor.constraint(equalTo: newsletterIcon.trailingAnchor, constant: 5),
                ])

                let button = UIButton(type: .system)
                button.backgroundColor = .clear //.red.withAlphaComponent(0.5)
                self.addSubview(button)
                button.activateConstraints([
                    button.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: colorView.topAnchor, constant: -self.buttonsMargin),
                    button.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: self.buttonsMargin),
                    button.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: self.buttonsMargin)
                ])
                button.addTarget(self, action: #selector(onNewsletterButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 138 + CSS.shared.navBar_icon_sepX
            }
        }
        
        self.refreshDisplayMode()
    }
    
    // MARK: - misc
    func refreshDisplayMode() {
        self.backgroundColor = CSS.shared.displayMode().main_bgColor
        
        for C in self.displayModeComponents {
        
            if(C is UIImageView) {
                
                let imgView = C as! UIImageView
                var img: UIImage?
                
                switch(imgView.tag) {
                    case 1: // logo
                        //imgView.image = UIImage(named: DisplayMode.imageName("navBar.circleLogo"))
                        img = UIImage(named: DisplayMode.imageName("verity.logo"))
                    case 2: // menu
                        img = UIImage(named: DisplayMode.imageName("newNavBar.menu"))
                    case 3: // search
                        img = UIImage(named: DisplayMode.imageName("newNavBar.search"))
                    case 4: // back (+ text)
                        img = UIImage(named: DisplayMode.imageName("circle.back"))
                    case 6: // back
                        img = UIImage(named: DisplayMode.imageName("circle.back"))
                    case 8: // share
                        img = UIImage(named: DisplayMode.imageName("circle.share"))
                    case 9: // user
                        img = UIImage(named: DisplayMode.imageName("newNavBar.user"))
                    case 10: // headlines
                        img = UIImage(named: DisplayMode.imageName("circle.home"))
                    case 12: // question
                        img = UIImage(named: DisplayMode.imageName("question"))
                    case 13: // info
                        img = UIImage(named: DisplayMode.imageName("info"))
                    case 14: // newsletter
                        img = UIImage(named: DisplayMode.imageName("newNavBar.newsletter"))
                    
                    default:
                        NOTHING()
                }
                
                if(imgView.tag == 14 && IPAD()) {
                    let colorView = imgView.superview!
                    colorView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x2d2d31) : UIColor(hex: 0xe3e3e3)
                    let label = colorView.viewWithTag(99) as! UILabel
                    label.textColor = CSS.shared.displayMode().main_textColor
                }
                
                imgView.image = img
//                if(imgView.tag==8) {
//                    imgView.tintColor = CSS.shared.displayMode().main_textColor
//                }
                
            }
            
            if(C is UILabel) {
                let label = C as! UILabel
                switch(label.tag) {
                    case 5, 7, 11: // BACK TO FEED
                        label.textColor = CSS.shared.displayMode().main_textColor
                        
                    default:
                        NOTHING()
                }
            }
        }
        
        if let _bottomLine = self.bottomLine {
            _bottomLine.backgroundColor = CSS.shared.displayMode().main_bgColor
            ADD_HDASHES(to: _bottomLine)
        }
    }
    
    func setTitle(_ text: String) {
        if let _label = self.viewWithTag(7) as? UILabel {
            _label.text = text
        } else if let _label = self.viewWithTag(11) as? UILabel {
            _label.text = text
            
            let _w = _label.calculateWidthFor(height: 32)
            if(_w > self.longTitleHSpace) {
                self.longTitleTrailingConstraint?.constant = self.longTitleTrailingValue_long
            } else {
                self.longTitleTrailingConstraint?.constant = self.longTitleTrailingValue_short
            }
        }
    }
    
    func setShareUrl(_ url: String, vc: UIViewController) {
        let _url = url.replacingOccurrences(of: "https://www.improvethenews.org",
            with: ITN_URL())
        
        self.shareUrl = _url
        self.vc = vc
    }
    
}

// MARK: - UI Fixes
extension NavBarView {

    static func HEIGHT() -> CGFloat {
        return Y_TOP_NOTCH_FIX(CSS.shared.navBar_height)
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
    
    @objc func onCustomBackButtonTap(_ sender: UIButton) {
        NOTIFY(Notification_customBackButtonTap)
    }
    
    @objc func onLogoButtonTap(_ sender: UIButton) {
        if(CustomNavController.shared.presentedViewController != nil) {
            CustomNavController.shared.dismiss(animated: true)
        }

        CustomNavController.shared.menu.gotoHeadlines(delayTime: 0)
    }
    
    @objc func onInfoButtonTap_2(_ sender: UIButton) {
        let vc = FAQViewController()
        vc.firstItemOpened = true
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
    @objc func onSearchButtonTap(_ sender: UIButton) {
//        let vc = SearchViewController()
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        CustomNavController.shared.tour?.cancel()
//        CustomNavController.shared.present(vc, animated: true)

        let vc = KeywordSearchViewController()
        //pushViewController(vc, animated: true)
        CustomNavController.shared.customAlphaPushViewController(vc)
    }
    
    @objc func onShareButtonTap(_ sender: UIButton) {
        if let _action = self.shareAction {
            _action()
        } else {
            if let _url = self.shareUrl, let _vc = self.vc {
                SHARE_URL(_url, from: _vc)
            }
        }
    }
    func onShareButtonTap(callback: @escaping () -> () ) {
        self.shareAction = callback
    }
    
    @objc func onQuestionButtonTap(_ sender: UIButton) {
        if let _action = self.questionAction {
            _action()
        }
    }
    func onQuestionButtonTap(callback: @escaping () -> () ) {
        self.questionAction = callback
    }
    
    @objc func onInfoButtonTap(_ sender: UIButton) {
        if let _action = self.infoAction {
            _action()
        }
    }
    func onInfoButtonTap(callback: @escaping () -> () ) {
        self.infoAction = callback
    }
    
    
    
    
    @objc func onTitleButtonTap(_ sender: UIButton) {
        if let _vc = CustomNavController.shared.viewControllers.last as? MainFeedViewController {
            _vc.scrollToZero()
        }
        
        if let _vc = CustomNavController.shared.viewControllers.last as? MainFeed_v3_viewController {
            _vc.list.scrollToTop()
        }
        
        if let _vc = CustomNavController.shared.viewControllers.last as? MainFeediPad_v3_viewController {
            _vc.list.scrollToTop()
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
    
    @objc func onHeadlinesButtonTap(_ sender: UIButton) {
        CustomNavController.shared.menu.gotoHeadlines(delayTime: 0)
    }
    
    @objc func onNewsletterButtonTap(_ sender: UIButton) {
        let vc = NewsletterSignUp()
        CustomNavController.shared.pushViewController(vc, animated: true)
    }
    
}
