//
//  PreferencesViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/11/2022.
//

import UIKit

class PreferencesViewController: BaseViewController {

    var list = UITableView()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow //DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            self.buildContent()
        }
    }
    
    // MARK: - misc
    func buildContent() {
        self.view.addSubview(self.list)
        self.list.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        self.list.backgroundColor = .systemPink
    }
    
}
