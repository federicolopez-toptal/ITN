//
//  MenuViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/09/2022.
//

import UIKit



enum MenuITem {
    case displayMode
    case headlines
}

class MenuViewController: BaseViewController {

    var list = UITableView()
    var versionLabel = UILabel()

    let dataProvider: [MenuITem] = [ // id(s)
        .headlines,
        .displayMode
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildContent()
    }
    
    // -----------------------------------
    private func buildContent() {
        self.view.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        let topSpace: CGFloat = Y_TOP_NOTCH_FIX(54)
        var bottomSpace: CGFloat = 5
        if let _extraSpace = SAFE_AREA()?.bottom {
            bottomSpace += _extraSpace * 0.6
        }
        
        self.view.addSubview(self.list)
        self.list.backgroundColor = self.view.backgroundColor
        self.list.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.list.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.list.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.list.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace + 45),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomSpace-25)
        ])
        self.list.separatorStyle = .none
        self.list.tableFooterView = UIView()
        self.list.delegate = self
        self.list.dataSource = self
        self.list.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        
        let vInfo = "version " + Bundle.main.releaseVersionNumber! + " (build " + Bundle.main.buildVersionNumber! + ")"
        
        self.view.addSubview(self.versionLabel)
        self.versionLabel.textColor = UIColor(hex: 0xFF643C)
        self.versionLabel.font = ROBOTO_BOLD(14)
        self.versionLabel.text = vInfo
        self.versionLabel.textAlignment = .center
        self.versionLabel.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)
        self.versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.versionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.versionLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -bottomSpace)
        ])
        
        let closeImage = UIImage(named: "menu.close")
        let closeIcon = UIImageView(image: closeImage)
        self.view.addSubview(closeIcon)
        closeIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeIcon.widthAnchor.constraint(equalToConstant: 32),
            closeIcon.heightAnchor.constraint(equalToConstant: 32),
            closeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            closeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSpace)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .clear //.red.withAlphaComponent(0.25)
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: closeIcon.leadingAnchor, constant: -5),
            closeButton.topAnchor.constraint(equalTo: closeIcon.topAnchor, constant: -5),
            closeButton.trailingAnchor.constraint(equalTo: closeIcon.trailingAnchor, constant: 5),
            closeButton.bottomAnchor.constraint(equalTo: closeIcon.bottomAnchor, constant: 5),
        ])
        closeButton.addTarget(self, action: #selector(onCloseButtonTap(_:)), for: .touchUpInside)
    }
    
    // MARK: - misc
    private func dismissMe() {
        CustomNavController.shared.dismissMenu()
    }
    
    // MARK: - Event(s)
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
}

// MARK: - Item(s)
extension MenuViewController {
    
    private func getText(forItem item: MenuITem) -> String {
        var result = ""
        
        switch(item) {
            case .displayMode:
                result = "Light mode"
                if(BRIGHT_MODE()){ result = "Dark mode" }
                
            case .headlines:
                result = "Headlines"
        }
        
        return result.uppercased()
    }
    
    private func getIcon(forItem item: MenuITem) -> UIImage {
        var icon = "menu.headlines"
        
        switch(item) {
            case .displayMode:
                icon = "gotoLight"
                if(BRIGHT_MODE()){ icon = "gotoDark" }
                
            case .headlines:
                icon = "headlines"
        }
        
        return UIImage(named: "menu." + icon)!
    }
    
    
    
    private func tapOnItem(_ item: MenuITem) {
        switch(item) {
            case .displayMode:
                self.changeDisplayMode()
                
            case .headlines:
                self.gotoHeadlines()
        }
    }
    
}

// MARK: - UITableView
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

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
        
        cell.titleLabel.text = self.getText(forItem: dpItem)
        cell.icon.image = self.getIcon(forItem: dpItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuItemCell.heigth
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataProvider[indexPath.row]
        self.tapOnItem(item)
    }
    
}

// MARK: - Menu action(s)
extension MenuViewController {
    
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
    
    func gotoHeadlines() {
        self.dismissMe()
        
        DELAY(0.5) {
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
    }
    
    private func gotoHeadlines_B() {
        if let _vc = CustomNavController.shared.viewControllers.first as? MainFeedViewController {
            _vc.tapOnLogo()
            _vc.data.resetCounting()
        }
    }
    
}
