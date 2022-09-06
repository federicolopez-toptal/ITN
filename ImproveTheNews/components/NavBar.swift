//
//  NavBar.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

extension MainFeedViewController {

    func buildNavBar() {
    
        // white background
        let rect = UIView()
        rect.backgroundColor = .white
        self.view.addSubview(rect)
        rect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rect.topAnchor.constraint(equalTo: self.view.topAnchor),
            rect.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            rect.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            rect.heightAnchor.constraint(equalToConstant: 100),
        ])
        self.displayModeComponentsNavBar.append(rect)
        
        // ITN logo
        let logo = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.logo")))
        rect.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: rect.centerXAnchor),
            logo.topAnchor.constraint(equalTo: rect.topAnchor, constant: 59),
            logo.widthAnchor.constraint(equalToConstant: 163),
            logo.heightAnchor.constraint(equalToConstant: 27)
        ])
        logo.tag = 2
        self.displayModeComponentsNavBar.append(logo)
        
        // < Hamburger
        let hamburgerIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.menu")))
        rect.addSubview(hamburgerIcon)
        hamburgerIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hamburgerIcon.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 15),
            hamburgerIcon.topAnchor.constraint(equalTo: rect.topAnchor, constant: 60),
            hamburgerIcon.widthAnchor.constraint(equalToConstant: 24),
            hamburgerIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        hamburgerIcon.tag = 3
        self.displayModeComponentsNavBar.append(hamburgerIcon)
        
        let menuButton = UIButton(type: .system)
        rect.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 10),
            menuButton.topAnchor.constraint(equalTo: rect.topAnchor, constant: 56),
            menuButton.widthAnchor.constraint(equalToConstant: 38),
            menuButton.heightAnchor.constraint(equalToConstant: 38)
        ])
        menuButton.addTarget(self, action: #selector(onMenuButtonTap(_:)), for: .touchUpInside)
        
        // > Search
        let searchIcon = UIImageView(image: UIImage(named: DisplayMode.imageName("navBar.search")))
        rect.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIcon.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -17),
            searchIcon.topAnchor.constraint(equalTo: rect.topAnchor, constant: 60),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        searchIcon.tag = 4
        self.displayModeComponentsNavBar.append(searchIcon)
        
        self.refreshDisplayModeNavBar()
    }
    
    func refreshDisplayModeNavBar() {
        let darkMode = (DisplayMode.current() == .dark)
    
        for component in self.displayModeComponentsNavBar {
            if(component is UIView) {
                let view = (component as! UIView)
                view.backgroundColor = darkMode ? UIColor(hex: 0x0B121E) : .white
            }
            
            if(component is UIImageView) {
                let imgView = component as! UIImageView
                switch(imgView.tag) {
                    case 2: // logo
                        imgView.image = UIImage(named: DisplayMode.imageName("navBar.logo"))
                    case 3: // menu
                        imgView.image = UIImage(named: DisplayMode.imageName("navBar.menu"))
                    case 4: // search
                        imgView.image = UIImage(named: DisplayMode.imageName("navBar.search"))
                    
                    default:
                        print("")
                }
            }
        }
    }
    
    // MARK: - Event(s)
    @objc func onMenuButtonTap(_ sender: UIButton) {
        (self.navigationController as! CustomNavController).callMenu()
    }

}
