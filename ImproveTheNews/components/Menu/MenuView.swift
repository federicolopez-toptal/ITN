//
//  MenuView.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 04/11/2022.
//

import UIKit

class MenuView: UIView {

    let MENU_WIDTH: CGFloat = 280

    var menuLeadingConstraint: NSLayoutConstraint?
    var list = UITableView()
    var versionLabel = UILabel()
    
    let dataProvider: [MenuITem] = [ // Items order
        .headlines,
        .displayMode,
        .tour,
        .preferences,
        .layout
    ]
    
    

    // MARK: - Init(s)
    init() {
        super.init(frame: CGRect.zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildInto(_ container: UIView) {
        container.addSubview(self)
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        
        self.menuLeadingConstraint = self.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        self.activateConstraints([
            self.menuLeadingConstraint!,
            self.topAnchor.constraint(equalTo: container.topAnchor),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            self.widthAnchor.constraint(equalToConstant: self.MENU_WIDTH)
        ])
        
        let topSpace: CGFloat = Y_TOP_NOTCH_FIX(54)
        var bottomSpace: CGFloat = 5
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
        
        let vInfo = "version " + Bundle.main.releaseVersionNumber! +
            " (build " + Bundle.main.buildVersionNumber! + ")"
        
        self.addSubview(self.versionLabel)
        self.versionLabel.textColor = UIColor(hex: 0xFF643C)
        self.versionLabel.font = ROBOTO_BOLD(14)
        self.versionLabel.text = vInfo
        self.versionLabel.textAlignment = .center
        self.versionLabel.backgroundColor = .clear //.yellow.withAlphaComponent(0.3)
        self.versionLabel.activateConstraints([
            self.versionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.versionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomSpace)
        ])
        
        let closeImage = UIImage(named: "menu.close")
        let closeIcon = UIImageView(image: closeImage)
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
        self.refreshDisplayMode()
    }
    
    // MARK: - misc
    func refreshDisplayMode() {
        self.backgroundColor = DARK_MODE() ? UIColor(hex: 0x0B121E) : .white
        self.list.backgroundColor = self.backgroundColor
        
        for (i, _) in self.dataProvider.enumerated() {
            let cell = self.tableView(self.list, cellForRowAt: IndexPath(row: i, section: 0)) as! MenuItemCell
            cell.refreshDisplayMode()
        }

        self.list.reloadData()
    }

}

// MARK: - Event(s)
extension MenuView {
    
    @objc func onCloseButtonTap(_ sender: UIButton) {
        self.dismissMe()
    }
    
    private func dismissMe() {
        self.refreshDisplayMode()
        CustomNavController.shared.dismissMenu()
    }
    
    // ---------
    func presentPreferences() {
        let vc = PreferencesViewController()
        CustomNavController.shared.viewControllers = [vc]
        
        DELAY(0.2) {
            self.dismissMe()
            CustomNavController.shared.slidersPanel.hide()
            CustomNavController.shared.floatingButton.hide()
        }
    }
    
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
    func gotoHeadlines(delayTime: TimeInterval = 0.5) {
        self.dismissMe()
        
        var firstIsMainFeed = false
        if let firstVC = CustomNavController.shared.viewControllers.first as? MainFeedViewController {
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
            let vc = MainFeedViewController()
            CustomNavController.shared.viewControllers = [vc]
            
            DELAY(0.2) {
                self.dismissMe()
                CustomNavController.shared.slidersPanel.show()
                CustomNavController.shared.floatingButton.show()
            }
        }
    }
    private func gotoHeadlines_B() {
        if let _vc = CustomNavController.shared.viewControllers.first as? MainFeedViewController {
            _vc.scrollToZero()
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
        NOTIFY(Notification_reloadMainFeed)

        
        let firstIsMainFeed = CustomNavController.shared.viewControllers.first! is MainFeedViewController
        if(firstIsMainFeed) {
            self.dismissMe()
        } else {
            let vc = MainFeedViewController()
            CustomNavController.shared.viewControllers = [vc]
            
            DELAY(0.2) {
                self.dismissMe()
                CustomNavController.shared.slidersPanel.show()
                CustomNavController.shared.floatingButton.show()
            }
        }
    }
    
    // ---------
    func startTour() {
        CustomNavController.shared.showTour = true
        CustomNavController.shared.slidersPanel.makeSureIsClosed()
        CustomNavController.shared.slidersPanel.forceSplitOff()
        
        let vc = MainFeedViewController()
        CustomNavController.shared.viewControllers = [vc]
        
        DELAY(0.3) {
            self.dismissMe()
        }
        
        // TODO: Llamar al Tour sin recargar las news (si ya estaban cargadas)
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
