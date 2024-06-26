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
    var wasInitialOrientationLandscape = false

    let dataProvider: [PreferenceItem] = [ // Items order
        .checkboxes,
        .sliders
    ]

    // MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if(!self.didLayout) {
            self.didLayout = true
            
            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Preferences")
            self.navBar.addBottomLine()
            
            self.buildContent()
            self.firstTime = true
            if(ORIENTATION_LANDSCAPE()) {
                self.wasInitialOrientationLandscape = true
            }
            
            CustomNavController.shared.slidersPanel.show(rows: 0)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.list.reloadData()
    }
    
    // MARK: - misc
    func buildContent() {

        self.view.addSubview(self.list)
        self.list.activateConstraints([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: IPAD_sideOffset()),
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
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
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

extension PreferencesViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
