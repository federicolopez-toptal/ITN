//
//  PublicFiguresViewController.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 19/03/2024.
//

import UIKit
import SDWebImage


class PublicFiguresViewController: BaseViewController {

    let navBar = NavBarView()
    var lastKeyTapTime: Date?
    
    var page: Int = 0
    var allItems = [PublicFigureListItem]()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let showMoreView = UIView()

    let noItemsLabel = UILabel()

        var filterTextfield = FigureFilterTextView()
        let itemsContainer = UIView()
        var itemsContainerHeightConstraint: NSLayoutConstraint!
        
        let items_DIM: CGFloat = 92
        var items_H_SEP: CGFloat = 92
        let items_V_SEP: CGFloat = 30
        var items_COLS: CGFloat = IPHONE() ? 2 : 5
        let imgs_DIM: CGFloat = 66
        let texts_WIDTH: CGFloat = 160
        
        var COL: CGFloat = 0
        var ROW: CGFloat = 0

    
    
    // MARK: - Init
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if(!self.didLayout) {
            self.didLayout = true

            self.navBar.buildInto(viewController: self)
            self.navBar.addComponents([.back, .title])
            self.navBar.setTitle("Public Figures")
            self.navBar.addBottomLine()

            self.buildContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavController.shared.hidePanelAndButtonWithAnimation()
    }
    
    func buildContent() {
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        CustomNavController.shared.interactivePopGestureRecognizer?.delegate = self // swipe to back
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = .systemPink
        self.scrollView.activateConstraints([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: NavBarView.HEIGHT()),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        let H = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
            H.priority = .defaultLow
            
        self.scrollView.addSubview(self.contentView)
        //self.contentView.backgroundColor = .yellow
        self.contentView.activateConstraints([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            H
        ])
        
        self.filterTextfield.delegate = self
        self.filterTextfield.buildInto(view: self.contentView)
        self.filterTextfield.activateConstraints([
            self.filterTextfield.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16*2),
            self.filterTextfield.heightAnchor.constraint(equalToConstant: 48),
        ])
        if(IPHONE()) {
            self.filterTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
            self.filterTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        } else {
            self.filterTextfield.widthAnchor.constraint(equalToConstant: 500).isActive = true
            self.filterTextfield.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        }

        var W: CGFloat = (self.items_COLS * self.items_DIM) + ((self.items_COLS-1) * self.items_H_SEP)
        if(IPAD()) {
            var value: CGFloat = 0
            let w = SCREEN_SIZE().width
            let h = SCREEN_SIZE().height
            
            value = w
            if(h<w){ value = h }
            
            if(value-W<30) {
                value -= (30 * 2)
                W = value
                value -= (self.items_COLS * self.items_DIM)
                
                self.items_H_SEP = value / (self.items_COLS-1)
            }
        }
        
        self.contentView.addSubview(self.itemsContainer)
        //self.itemsContainer.backgroundColor = .orange
        self.itemsContainer.activateConstraints([
            self.itemsContainer.topAnchor.constraint(equalTo: self.filterTextfield.bottomAnchor, constant: 16*2),
            self.itemsContainer.widthAnchor.constraint(equalToConstant: W),
            self.itemsContainer.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        self.itemsContainerHeightConstraint = self.itemsContainer.heightAnchor.constraint(equalToConstant: 300)
        self.itemsContainerHeightConstraint.isActive = true
        
        //self.showMoreView.backgroundColor = .orange
        self.contentView.addSubview(self.showMoreView)
        self.showMoreView.activateConstraints([
            self.showMoreView.widthAnchor.constraint(equalToConstant: 150),
            self.showMoreView.heightAnchor.constraint(equalToConstant: 42+16),
            self.showMoreView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.showMoreView.topAnchor.constraint(equalTo: self.itemsContainer.bottomAnchor),
            
            self.showMoreView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -22)
        ])
        
        let showMoreButton = UIButton(type: .custom)
        self.showMoreView.addSubview(showMoreButton)
        showMoreButton.activateConstraints([
            showMoreButton.heightAnchor.constraint(equalToConstant: 42),
            showMoreButton.widthAnchor.constraint(equalToConstant: 150),
            showMoreButton.leadingAnchor.constraint(equalTo: self.showMoreView.leadingAnchor),
            showMoreButton.topAnchor.constraint(equalTo: self.showMoreView.topAnchor, constant: 16)
        ])
        showMoreButton.setTitle("Show more", for: .normal)
        showMoreButton.setTitleColor(CSS.shared.displayMode().main_textColor, for: .normal)
        showMoreButton.titleLabel?.font = AILERON(15)
        showMoreButton.layer.masksToBounds = true
        showMoreButton.layer.cornerRadius = 9
        showMoreButton.backgroundColor = DARK_MODE() ? UIColor(hex: 0x28282D) : UIColor(hex: 0xE8E9EA)
        showMoreButton.addTarget(self, action: #selector(loadMoreOnTap(_:)), for: .touchUpInside)
        
        self.noItemsLabel.font = AILERON(16)
        self.noItemsLabel.textAlignment = .center
        self.noItemsLabel.textColor = CSS.shared.displayMode().sec_textColor
        self.noItemsLabel.numberOfLines = 0
        self.noItemsLabel.text = "No items found\nPlease, try another search"
        self.contentView.addSubview(self.noItemsLabel)
        self.noItemsLabel.activateConstraints([
            self.noItemsLabel.topAnchor.constraint(equalTo: self.itemsContainer.topAnchor, constant: 20),
            self.noItemsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        self.noItemsLabel.hide()
        
        self.scrollView.hide()
        self.refreshDisplayMode()
    }
    
    @objc func loadMoreOnTap(_ sender: UIButton) {
        self.loadContent(page: self.page)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!self.didAppear) {
            self.didAppear = true
            
            self.resetListParams()
            self.loadContent(page: self.page)
        }
    }
    
    func resetListParams() {
        self.COL = 0
        self.ROW = 0
        self.page = 1
        self.allItems = [PublicFigureListItem]()
        REMOVE_ALL_SUBVIEWS(from: self.itemsContainer)
    }
    
    override func refreshDisplayMode() {
        self.navBar.refreshDisplayMode()
        self.view.backgroundColor = CSS.shared.displayMode().main_bgColor
        self.scrollView.backgroundColor = self.view.backgroundColor
        
        //self.contentView.backgroundColor = self.view.backgroundColor
        //self.VStack.backgroundColor = self.view.backgroundColor
    }

}

// MARK: Data
extension PublicFiguresViewController {
    
    private func loadContent(page P: Int) {
        self.showLoading()
        PublicFigureData.shared.loadList(term: self.filterTextfield.text(), page: P) { (error, total, items) in
            if let _ = error {
                ALERT(vc: self, title: "Server error",
                message: "Trouble loading the Public Figures,\nplease try again later.", onCompletion: {
                    CustomNavController.shared.popViewController(animated: true)
                })
            } else {
                self.page += 1
            
                MAIN_THREAD {
                    self.hideLoading()
                    
                    if let _T = total, let _I = items {
                        self.fillList(total: _T, items: _I)
                    }
                }
            }
        }
                
    }
    
    func fillList(total: Int, items: [PublicFigureListItem]) {
        for LI in items {
            let newItem = self.createItemView(data: LI)
            let posX: CGFloat = self.COL * (self.items_DIM + self.items_H_SEP)
            let posY: CGFloat = self.ROW * ((self.items_DIM+40) + self.items_V_SEP)
            
            self.itemsContainer.addSubview(newItem)
            newItem.activateConstraints([
                newItem.leadingAnchor.constraint(equalTo: self.itemsContainer.leadingAnchor, constant: posX),
                newItem.topAnchor.constraint(equalTo: self.itemsContainer.topAnchor, constant: posY)
            ])
         
            self.itemsContainerHeightConstraint.constant = posY + self.items_DIM+40 + 16
         
            self.COL += 1
            if(self.COL == self.items_COLS) {
                self.COL = 0
                self.ROW += 1
            }
            
            self.allItems.append(LI)
        }
        
        if(self.allItems.count < total) {
            self.showMoreView.show()
        } else {
            self.showMoreView.hide()
        }
        
        self.scrollView.show()
        
        if(total == 0) {
            self.noItemsLabel.show()
        } else {
            self.noItemsLabel.hide()
        }
    }
    
    private func createItemView(data: PublicFigureListItem) -> UIView {
        let mainView = UIView()
        //mainView.backgroundColor = .cyan
        mainView.activateConstraints([
            mainView.widthAnchor.constraint(equalToConstant: self.items_DIM),
            mainView.heightAnchor.constraint(equalToConstant: self.items_DIM + 40)
        ])
    
        let borderView = UIView()
        mainView.addSubview(borderView)
        borderView.backgroundColor = DARK_MODE() ? UIColor(hex: 0x232326) : UIColor(hex: 0xE3E3E3)
        borderView.activateConstraints([
            borderView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            borderView.topAnchor.constraint(equalTo: mainView.topAnchor),
            borderView.widthAnchor.constraint(equalToConstant: self.items_DIM),
            borderView.heightAnchor.constraint(equalToConstant: self.items_DIM)
        ])
        borderView.layer.cornerRadius = self.items_DIM/2
        
        let imageView = UIImageView()
        imageView.backgroundColor = DARK_MODE() ? .white.withAlphaComponent(0.05) : .black.withAlphaComponent(0.1)
        borderView.addSubview(imageView)
        imageView.activateConstraints([
            imageView.widthAnchor.constraint(equalToConstant: self.imgs_DIM),
            imageView.heightAnchor.constraint(equalToConstant: self.imgs_DIM),
            imageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        ])
        imageView.layer.cornerRadius = self.imgs_DIM/2
        imageView.clipsToBounds = true
        imageView.sd_setImage(with: URL(string: data.image))
        
        let nameLabel = UILabel()
        //nameLabel.backgroundColor = .orange
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = AILERON(16)
        nameLabel.textColor = CSS.shared.displayMode().main_textColor
        nameLabel.text = data.title
        //
        mainView.addSubview(nameLabel)
        nameLabel.activateConstraints([
            nameLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: self.texts_WIDTH),
            nameLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor)
        ])
        
        let buttonArea = UIButton(type: .custom)
        //buttonArea.backgroundColor = .red.withAlphaComponent(0.5)
        mainView.addSubview(buttonArea)
        buttonArea.activateConstraints([
            buttonArea.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            buttonArea.topAnchor.constraint(equalTo: mainView.topAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        buttonArea.tag = data.id
        buttonArea.addTarget(self, action: #selector(listItemOnTap(_:)), for: .touchUpInside)
        
        return mainView
    }
    
    @objc func listItemOnTap(_ sender: UIButton) {
        if let _item = self.allItems.first(where: { $0.id == sender.tag }) {
            let vc = FigureDetailsViewController()
            vc.slug = _item.slug
            CustomNavController.shared.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: misc
extension PublicFiguresViewController: UIGestureRecognizerDelegate {
    
    // to swipe BACK
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}

// MARK:
extension PublicFiguresViewController: FigureFilterTextViewDelegate {

    func FigureFilterTextView_onTextChange(sender: FigureFilterTextView, text: String) {
        let limitDiff: TimeInterval = 0.8
        self.lastKeyTapTime = Date()

        DELAY(limitDiff) {
            let diff = Date().timeIntervalSince(self.lastKeyTapTime!)
            if(diff >= limitDiff) {
                //self.search(self.searchTextfield.text(), type: .all)
                self.resetListParams()
                self.loadContent(page: self.page)
            }
        }
    }
    
    func FigureFilterTextView_onSearchTap(sender: FigureFilterTextView) {
        NOTHING()
    }
    
}