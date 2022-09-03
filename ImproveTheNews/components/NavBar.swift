//
//  NavBar.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 31/08/2022.
//

import UIKit

extension MainFeedViewController {

    func setNavBar() {
        
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
        
        // ITN logo
        let logo = UIImageView(image: UIImage(named: "ITN_logo_bright"))
        rect.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: rect.centerXAnchor),
            logo.topAnchor.constraint(equalTo: rect.topAnchor, constant: 59),
            logo.widthAnchor.constraint(equalToConstant: 163),
            logo.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        // < Hamburger
        let hamburgerIcon = UIImageView(image: UIImage(named: "hamburger_bright"))
        rect.addSubview(hamburgerIcon)
        hamburgerIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hamburgerIcon.leadingAnchor.constraint(equalTo: rect.leadingAnchor, constant: 18),
            hamburgerIcon.topAnchor.constraint(equalTo: rect.topAnchor, constant: 66),
            hamburgerIcon.widthAnchor.constraint(equalToConstant: 18),
            hamburgerIcon.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // > Search
        let searchIcon = UIImageView(image: UIImage(named: "search_bright"))
        rect.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIcon.trailingAnchor.constraint(equalTo: rect.trailingAnchor, constant: -21),
            searchIcon.topAnchor.constraint(equalTo: rect.topAnchor, constant: 63),
            searchIcon.widthAnchor.constraint(equalToConstant: 18),
            searchIcon.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

}
