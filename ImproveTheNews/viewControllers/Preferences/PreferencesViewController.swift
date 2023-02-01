//
//  PreferencesViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 03/11/2022.
//

import UIKit


class PreferencesViewController: BaseViewController {

    let navBar = NavBarView()
    var list = UITableView()
    var firstTime = false

    let dataProvider: [PreferenceItem] = [ // Items order
        .checkboxes,
        .sliders
    ]



    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.logo, .menuIcon, .searchIcon])
            
            self.buildContent()
            self.firstTime = true
            
            CustomNavController.shared.slidersPanel.show(rows: 0)
        }
    }
    
    // MARK: - misc
    func buildContent() {
        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        
        self.list.register(PrefCheckboxes_cell.self, forCellReuseIdentifier: PrefCheckboxes_cell.identifier)
        self.list.register(PrefSliders_cell.self, forCellReuseIdentifier: PrefSliders_cell.identifier)
        
        self.list.delegate = self
        self.list.dataSource = self

        self.refreshDisplayMode()
    }
    
    override func refreshDisplayMode() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.view.backgroundColor
        self.navBar.refreshDisplayMode()
        
        if(!self.firstTime){ return }
        for (i, _) in self.dataProvider.enumerated() {
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = self.getCellForIndexPath(indexPath) as? PrefCheckboxes_cell {
                cell.refreshDisplayMode()
            }
//            else if let cell = self.getCellForIndexPath(indexPath) as? PrefSliders_cell {
//                cell.refreshDisplayMode()
//            }
        }
        
        self.list.reloadData()
        CustomNavController.shared.floatingButton.hide()
    }
    
    func scrollToSliders() {
        self.list.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top, animated: true)
    }
    
}

// MARK: - UITableView
extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCellForIndexPath(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.getCellHeight(indexPath)
    }
}
