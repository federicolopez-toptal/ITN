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
}


class NavBarView: UIView {

    var displayModeComponents = [Any]()

    private let buttonsMargin: CGFloat = 5.0
    private var left_x: CGFloat = 15
    private var right_x: CGFloat = 15
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Build component
    func buildInto(_ container: UIView) {
        self.backgroundColor = .white
        container.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: 101),
        ])
        
        self.refreshDisplayMode()
    }
    
    func addComponents(_ components: [NavBarViewComponents]) {
        for C in components {
            if(C == .logo) {
                // ITN logo
                let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.logo")))
                self.addSubview(logo)
                logo.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 59),
                    logo.widthAnchor.constraint(equalToConstant: 163),
                    logo.heightAnchor.constraint(equalToConstant: 27)
                ])
                logo.tag = 1
                self.displayModeComponents.append(logo)
            }
            
            if(C == .menuIcon) {
                // Menu
                let menuIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.menu")))
                self.addSubview(menuIcon)
                menuIcon.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    menuIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.left_x),
                    menuIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
                    menuIcon.widthAnchor.constraint(equalToConstant: 24),
                    menuIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                menuIcon.tag = 2
                self.displayModeComponents.append(menuIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: menuIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: menuIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: menuIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: menuIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                button.addTarget(self, action: #selector(onMenuButtonTap(_:)), for: .touchUpInside)
                
                self.left_x += 24 + 15
            }
            
            if(C == .searchIcon) {
                let searchIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.search")))
                self.addSubview(searchIcon)
                searchIcon.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    searchIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.right_x),
                    searchIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
                    searchIcon.widthAnchor.constraint(equalToConstant: 24),
                    searchIcon.heightAnchor.constraint(equalToConstant: 24)
                ])
                searchIcon.tag = 3
                self.displayModeComponents.append(searchIcon)
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear
                self.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -self.buttonsMargin),
                    button.topAnchor.constraint(equalTo: searchIcon.topAnchor, constant: -self.buttonsMargin),
                    button.widthAnchor.constraint(equalTo: searchIcon.widthAnchor, constant: self.buttonsMargin * 2),
                    button.heightAnchor.constraint(equalTo: searchIcon.heightAnchor, constant: self.buttonsMargin * 2)
                ])
                //button.addTarget(self, action: #selector(onMenuButtonTap(_:)), for: .touchUpInside)
                
                self.right_x += 24 + 15
            }
        }
    }
    
    // MARK: - Display mode
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        for C in self.displayModeComponents {
            if(C is UIImageView) {
                let imgView = C as! UIImageView
                switch(imgView.tag) {
                    case 1: // logo
                        imgView.image = UIImage(named: DisplayMode.imageName("navBar.logo"))
                    case 2: // menu
                        imgView.image = UIImage(named: DisplayMode.imageName("navBar.menu"))
                    case 3: // search
                        imgView.image = UIImage(named: DisplayMode.imageName("navBar.search"))
                    
                    default:
                        print("")
                }
            }
        }
    }

}

// MARK: - Event(s)
extension NavBarView {
    
    @objc func onMenuButtonTap(_ sender: UIButton) {
        CustomNavController.shared.callMenu()
    }
    
}
